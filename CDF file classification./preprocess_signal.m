function [data_processed, times_processed] = preprocess_signal(data_raw, data_length, compression, sampling_rate)
%%% This function process raw data to the format expected by the dust classifier 
% 
% Input:
% data_raw      = [array] raw antenna voltage [1xN] samples
% data_length   = [scalar] length (N) of data_raw
% compression   = [scalar] compression factor used for CNN (e.g. 8) 
% sampling_rate = [scalar] intrument sampling rate (e.g. 2.6213750e+05)
%
% Output: 
% data_processed  = [array] processed voltage samples [1x(N/compression)]
% times_processed = [array] processed time steps [1x(N/compression)]

%% 1 - Determine raw and processed time steps 
times_raw = (0:1:(data_length-1))/sampling_rate;
times_processed = linspace(times_raw(1),times_raw(end),round(data_length/compression));

%% 2 - Heavy median filtering of the data for bias removal
F = 21;
data_filtered = medfilt1(data_raw,F);

%% 3 - Determine the median of the data (the potential bias)
data_median = median(data_filtered);

%% 4 - Step 1: Remove the potential bias 
data_nobias = data_raw - data_median;

%% 5 - Step 2: Filter the data using a median filter of length 7
data_filtered = medfilt1(data_nobias,7);

%% 6 - Step 3: Compress the signal with factor: compression
data_compressed = interp1(times_raw,data_filtered,times_processed);

%% 7 - Step 4: Noramlize the data with respect to the maximum absolute value
mx = max(abs(data_compressed));
data_processed = data_compressed./(mx);

end
