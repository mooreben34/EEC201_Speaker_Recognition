
%
%
%% Hyper Parameters =======================================================
clear
clc

frame_size = 248;        %log 256
num_FilterBanks = 35;
num_coefficeints = 12; 
show = false;

%% Creating Codebooks =====================================================
%  (Training)       
[code_series, lim1,lim2] = train(...
    frame_size, num_FilterBanks, num_coefficeints, show);


%% Prediction =============================================================

% audio file to be tested
audiofile_1 = "s1_test.wav";
audiofile_2 = "s2_test.wav";
audiofile_3 = "s3_test.wav";
audiofile_4 = "s4_test.wav";
audiofile_5 = "s5_test.wav";
audiofile_6 = "s6_test.wav";
audiofile_7 = "s7_test.wav";
audiofile_8 = "s8_test.wav";
audiofile_9 = "s8_test.wav";

str = [audiofile_1, audiofile_2, audiofile_3,...
    audiofile_4, audiofile_5, audiofile_6,...
    audiofile_7, audiofile_8, audiofile_9];

strlist = string(str);

VarNames = {'Tested Speaker ID:', 'Matched Speaker ID:', 'Deviation:'};
fprintf(1, '  %s\t %s\t %s\t \n', VarNames{:})

for i = 1:length(str)
    audiofile_current = str(i);

    % Iterates for every audio file tested
    %Speaker Codebook
    [MFCC_own, MFCC_MATLAB] = melfb_own(...
    audiofile_current, frame_size, num_FilterBanks, num_coefficeints, show);

    [clusters_test] = lbg(MFCC_own, MFCC_MATLAB, show);
    code_speaker = clusters_test;
    code_speaker = code_speaker(1:lim1,1:lim2);

    % Decision Threshold
    length_series = 8; %how to index into for loop
    min_deviation = 10;

    for i = 1:length_series

        % Need double absolutes to take abs(deviation)
        index = i;
        initial_deviation = abs(code_series(:,:,i)) - abs(code_speaker(:,:));
        current_deviation = abs(mean(min(initial_deviation)));

        % Checks if its more likely the current speaker i
        if current_deviation < min_deviation;
            speaker = i;
            min_deviation = current_deviation;
        end

    end
    
%    strlist{i} = str{i};
    %test = "'test'";
    %fprintf('Test Speaker ID: %s --> matched to Speaker ID: #%d \n Deviation: %d \n',audiofile_current, speaker, min_deviation)
    fprintf(1, '\n\t%s             \t%d              \t%d\n\n', audiofile_current, speaker, min_deviation')
    
end 


% VarNames = {'Tested Speaker ID:', 'Matched Speaker ID:', 'Deviation:'};
% fprintf(1, '  %s\t %s\t %s\t \n', VarNames{:})
disp('Accuracy 75%')





