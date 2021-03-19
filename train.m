%
%
%% Training ===============================================================

function [code_series, lim1,lim2] = train(...
    frame_size, num_FilterBanks, num_coefficeints, show)

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s1.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s1] = lbg(MFCC_own, MFCC_MATLAB, show);

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s2.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s2] = lbg(MFCC_own, MFCC_MATLAB, show);

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s3.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s3] = lbg(MFCC_own, MFCC_MATLAB, show);

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s4.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s4] = lbg(MFCC_own, MFCC_MATLAB, show); 

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s5.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s5] = lbg(MFCC_own, MFCC_MATLAB, show);

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s6.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s6] = lbg(MFCC_own, MFCC_MATLAB, show);

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s7.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s7] = lbg(MFCC_own, MFCC_MATLAB, show);

    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    "s8.wav", frame_size, num_FilterBanks, num_coefficeints, show);
    [clusters_s8] = lbg(MFCC_own, MFCC_MATLAB, show);

    %DimensionReduction (Truncating)
    lim1 = height(clusters_s1);
    lim2 = width(clusters_s1);

    code_series(:,:,1) = clusters_s1;
    code_series(:,:,2) = clusters_s2(1:lim1,1:lim2);
    code_series(:,:,3) = clusters_s3;
    code_series(:,:,4) = clusters_s4;
    code_series(:,:,5) = clusters_s5;
    code_series(:,:,6) = clusters_s6;
    code_series(:,:,7) = clusters_s7;
    code_series(:,:,8) = clusters_s8;

end