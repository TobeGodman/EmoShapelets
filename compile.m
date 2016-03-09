function compile()

    % compile trillion code
    fprintf('*** compiling trillion code *** \n')
    mex external/trillion/source_code/UCR_DTW_matlab.cpp -outdir external/trillion/source_code/

    % compile libsvm
    fprintf('*** compiling libSVM code *** \n')
    cd external/libsvm-3.21/matlab
    make    
    cd ../../../

    % compile mrmr code
    fprintf('*** compiling mRMR code ***\n')
    cd external/mrmr_d_matlab_src/mi/
    makeosmex
    cd ../../../

end