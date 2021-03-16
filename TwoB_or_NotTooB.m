
%% Creating Codebooks =====================================================
%  (Training)       
clear
[MFCC_own, MFCC_MATLAB] = melfb_own("s1.wav", 256, 40, 13);
[clusters_s1] = lbg(MFCC_own, MFCC_MATLAB);

[MFCC_own, MFCC_MATLAB] = melfb_own("s2.wav", 256, 40, 13);
[clusters_s2] = lbg(MFCC_own, MFCC_MATLAB);

[MFCC_own, MFCC_MATLAB] = melfb_own("s3.wav", 256, 40, 13);
[clusters_s3] = lbg(MFCC_own, MFCC_MATLAB);

[MFCC_own, MFCC_MATLAB] = melfb_own("s4.wav", 256, 40, 13);
[clusters_s4] = lbg(MFCC_own, MFCC_MATLAB); 

[MFCC_own, MFCC_MATLAB] = melfb_own("s5.wav", 256, 40, 13);
[clusters_s5] = lbg(MFCC_own, MFCC_MATLAB);

[MFCC_own, MFCC_MATLAB] = melfb_own("s6.wav", 256, 40, 13);
[clusters_s6] = lbg(MFCC_own, MFCC_MATLAB);

[MFCC_own, MFCC_MATLAB] = melfb_own("s7.wav", 256, 40, 13);
[clusters_s7] = lbg(MFCC_own, MFCC_MATLAB);

[MFCC_own, MFCC_MATLAB] = melfb_own("s8.wav", 256, 40, 13);
[clusters_s8] = lbg(MFCC_own, MFCC_MATLAB);



%% Prediction =============================================================

%Speaker Codebook
[MFCC_own, MFCC_MATLAB] = melfb_own("s2_test.wav", 256, 40, 13);
[clusters_s2_test] = lbg(MFCC_own, MFCC_MATLAB);
code_speaker = clusters_s2_test;

%DimensionReduction (Truncating)
lim_1 = height(clusters_s1);
lim_2 = width(clusters_s1);

code_series(:,:,1) = clusters_s1;
code_series(:,:,2) = clusters_s2(lim_1,lim_2);
code_series(:,:,3) = clusters_s3(lim_1,lim_2);
code_series(:,:,4) = clusters_s4;
code_series(:,:,5) = clusters_s5;
code_series(:,:,6) = clusters_s6;
code_series(:,:,7) = clusters_s7;
code_series(:,:,8) = clusters_s8;
code_speaker = code_speaker(lim_1,lim_2);

length_series = 8; %how to index into for loop
min_deviation = 10;

for i = 1:length_series

current_deviation = mean(min(abs(code_series(:,:,i) - code_speaker)));

% Checks if its more likely the current speaker i
if current_deviation < min_deviation
    speaker = i
    min_deviation = current_deviation;
end

end
sprintf("Test Speaker ID: #2 matched to Speaker ID: #%d", speaker)








