#include "gpuKernelEvaluator.H"

#include <iostream>

#include "cuda_host_dev.H"
#include "gpuBuffer.H"
#include "gpuMemoryResource2.H"
#include "host_device_vectors.H"
#include "error_handling.H"
#include <thrust/execution_policy.h>
#include <thrust/extrema.h> //min_element
#include <thrust/host_vector.h>

#include "variant.hpp"
#include <thrust/device_malloc_allocator.h>

namespace FoamGpu {

GpuKernelEvaluator::GpuKernelEvaluator(
    gLabel                          nCells,
    gLabel                          nEqns,
    gLabel                          nSpecie,
    const std::vector<gpuThermo>&   thermos,
    const std::vector<gpuReaction>& reactions,
    gpuODESolverInputs              odeInputs)
    : nEqns_(nEqns)
    , nSpecie_(nSpecie)
    , nReactions_(gLabel(reactions.size()))
    , thermosReactions_(thermos, reactions)
    , system_(nEqns_,
              gLabel(reactions.size()),
              thermosReactions_.thermos(),
              thermosReactions_.reactions())
    , solver_(make_gpuODESolver(system_, odeInputs))
    , inputs_(odeInputs)
    , memory_(nCells, nSpecie) {

    int num;
    CHECK_CUDA_ERROR(cudaGetDeviceCount(&num)); // number of CUDA devices

    int dev = (nCells % num);
    //cudaDeviceProp::canMapHostMemory prop;
    //CHECK_CUDA_ERROR(cudaChooseDevice(&dev, &prop));


    CHECK_CUDA_ERROR(cudaSetDevice(dev));
    std::cout << "Using device: " << dev << std::endl;


    /*
    for (int i = 0; i < num; i++) {
        // Query the device properties.
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop, i);
        std::cout << "Device id: " << i << std::endl;
        std::cout << "Device name: " << prop.name << std::endl;
    }
    */
}

template <class ODE> struct singleCell {

    singleCell(gScalar              deltaT,
               gLabel               nSpecie,
               mdspan<gScalar, 1>   deltaTChem,
               mdspan<gScalar, 2>   Yvf,
               mdspan<gpuBuffer, 1> buffer,
               ODE                  ode)
        : deltaT_(deltaT)
        , nSpecie_(nSpecie)
        , deltaTChem_(deltaTChem)
        , Yvf_(Yvf)
        , buffer_(buffer)
        , ode_(ode) {}

    CUDA_HOSTDEV void operator()(gLabel celli) const {
        auto Y = mdspan<gScalar, 1>(&Yvf_(celli, 0), extents<1>{nSpecie_ + 2});

        // Initialise time progress
        gScalar timeLeft = deltaT_;

        constexpr gLabel li = 0;

        // Calculate the chemical source terms
        while (timeLeft > gpuSmall) {
            gScalar dt = timeLeft;

            ode_.solve(0, dt, Y, li, deltaTChem_[celli], buffer_[celli]);

            for (int i = 0; i < nSpecie_; i++) { Y[i] = std::max(0.0, Y[i]); }

            timeLeft -= dt;
        }
    }

    gScalar              deltaT_;
    gLabel               nSpecie_;
    mdspan<gScalar, 1>   deltaTChem_;
    mdspan<gScalar, 2>   Yvf_;
    mdspan<gpuBuffer, 1> buffer_;
    ODE                  ode_;
};

std::pair<std::vector<gScalar>, std::vector<gScalar>>
GpuKernelEvaluator::computeYNew(gScalar                     deltaT,
                                gScalar                     deltaTChemMax,
                                const std::vector<gScalar>& deltaTChem,
                                const std::vector<gScalar>& Y) {

    const gLabel nCells = deltaTChem.size();

    // Convert fields from host to device
    auto ddeltaTChem_arr = toDeviceVector(deltaTChem);
    auto dYvf_arr        = toDeviceVector(Y);
    auto ddeltaTChem     = make_mdspan(ddeltaTChem_arr, extents<1>{nCells});
    auto dYvf            = make_mdspan(dYvf_arr, extents<2>{nCells, nEqns_});

    auto buffers     = toDeviceVector(splitToBuffers(memory_));
    auto buffer_span = make_mdspan(buffers, extents<1>{nCells});

    singleCell op(deltaT, nSpecie_, ddeltaTChem, dYvf, buffer_span, solver_);

    thrust::for_each(thrust::device,
                     thrust::make_counting_iterator(0),
                     thrust::make_counting_iterator(nCells),
                     op);

    return std::make_pair(toStdVector(dYvf_arr), toStdVector(ddeltaTChem_arr));
}

std::tuple<std::vector<gScalar>, std::vector<gScalar>, gScalar>
GpuKernelEvaluator::computeRR(gScalar                    deltaT,
                              gScalar                    deltaTChemMax,
                              const std::vector<gScalar> rho,
                              const std::vector<gScalar> deltaTChem,
                              const std::vector<gScalar> Y) {

    const gLabel nCells = rho.size();

    auto pair          = computeYNew(deltaT, deltaTChemMax, deltaTChem, Y);
    auto YNew_arr      = std::get<0>(pair);
    auto deltaTChemNew = std::get<1>(pair);

    auto YNew = make_mdspan(YNew_arr, extents<2>{nCells, nEqns_});
    auto Y0   = make_mdspan(Y, extents<2>{nCells, nEqns_});

    std::vector<gScalar> RR_arr(nCells * nSpecie_);
    auto                 RR = make_mdspan(RR_arr, extents<2>{nCells, nSpecie_});

    for (gLabel j = 0; j < nCells; ++j) {
        for (gLabel i = 0; i < nSpecie_; ++i) {

            RR(j, i) = rho[j] * (YNew(j, i) - Y0(j, i)) / deltaT;
        }
    }

    gScalar deltaTMin =
        *std::min_element(deltaTChemNew.begin(), deltaTChemNew.end());

    for (auto& e : deltaTChemNew) { e = std::min(e, deltaTChemMax); }

    return std::make_tuple(RR_arr, deltaTChemNew, deltaTMin);
}

} // namespace FoamGpu