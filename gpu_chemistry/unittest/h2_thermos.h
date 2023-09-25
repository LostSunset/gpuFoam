R"(species         10 ( H2 H O2 O OH HO2 H2O2 H2O AR N2 );

OH
{
    specie
    {
        molWeight       17.00737;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.88273 0.001013974 -2.276877e-07 2.174684e-11 -5.126305e-16 3886.888 5.595712 );
        lowCpCoeffs     ( 3.637266 0.000185091 -1.676165e-06 2.387203e-09 -8.431442e-13 3606.782 1.35886 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        O               1;
        H               1;
    }
}

N2
{
    specie
    {
        molWeight       28.0134;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.92664 0.001487977 -5.684761e-07 1.009704e-10 -6.753351e-15 -922.7977 5.980528 );
        lowCpCoeffs     ( 3.298677 0.00140824 -3.963222e-06 5.641515e-09 -2.444855e-12 -1020.9 3.950372 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        N               2;
    }
}

H2O2
{
    specie
    {
        molWeight       34.01474;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 4.573167 0.004336136 -1.474689e-06 2.348904e-10 -1.431654e-14 -18006.96 0.501137 );
        lowCpCoeffs     ( 3.388754 0.006569226 -1.485013e-07 -4.625806e-09 2.471515e-12 -17663.15 6.785363 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        H               2;
        O               2;
    }
}

O2
{
    specie
    {
        molWeight       31.9988;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 3.697578 0.0006135197 -1.258842e-07 1.775281e-11 -1.136435e-15 -1233.93 3.189166 );
        lowCpCoeffs     ( 3.212936 0.001127486 -5.75615e-07 1.313877e-09 -8.768554e-13 -1005.249 6.034738 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        O               2;
    }
}

H2
{
    specie
    {
        molWeight       2.01594;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.991423 0.0007000644 -5.633829e-08 -9.231578e-12 1.582752e-15 -835.034 -1.35511 );
        lowCpCoeffs     ( 3.298124 0.0008249442 -8.143015e-07 -9.475434e-11 4.134872e-13 -1012.521 -3.294094 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        H               2;
    }
}

HO2
{
    specie
    {
        molWeight       33.00677;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 4.072191 0.002131296 -5.308145e-07 6.112269e-11 -2.841165e-15 -157.9727 3.476029 );
        lowCpCoeffs     ( 2.979963 0.004996697 -3.790997e-06 2.354192e-09 -8.089024e-13 176.2274 9.222724 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        H               1;
        O               2;
    }
}

O
{
    specie
    {
        molWeight       15.9994;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.54206 -2.755062e-05 -3.102803e-09 4.551067e-12 -4.368052e-16 29230.8 4.920308 );
        lowCpCoeffs     ( 2.946429 -0.001638166 2.421032e-06 -1.602843e-09 3.890696e-13 29147.64 2.963995 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        O               1;
    }
}

H2O
{
    specie
    {
        molWeight       18.01534;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.672146 0.003056293 -8.73026e-07 1.200996e-10 -6.391618e-15 -29899.21 6.862817 );
        lowCpCoeffs     ( 3.386842 0.003474982 -6.354696e-06 6.968581e-09 -2.506588e-12 -30208.11 2.590233 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        H               2;
        O               1;
    }
}

H
{
    specie
    {
        molWeight       1.00797;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.5 0 0 0 0 25471.63 -0.4601176 );
        lowCpCoeffs     ( 2.5 0 0 0 0 25471.63 -0.4601176 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        H               1;
    }
}

AR
{
    specie
    {
        molWeight       39.948;
    }
    thermodynamics
    {
        Tlow            200;
        Thigh           5000;
        Tcommon         1000;
        highCpCoeffs    ( 2.5 0 0 0 0 -745.375 4.366001 );
        lowCpCoeffs     ( 2.5 0 0 0 0 -745.375 4.366001 );
    }
    transport
    {
        As              0;
        Ts              0;
    }
    elements
    {
        Ar              1;
    }
})"
