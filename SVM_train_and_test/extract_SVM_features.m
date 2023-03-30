function [features] = extract_SVM_features(data)
% This function extracts 2D features for SVM classification
% 
% Input:
% data     = [matrix] pre-processed data in [Nx12288] format, where 
%            12288 = 3*4096 are the antenna measurements for N observations  
%
% Output: 
% features  = [Nx2] 2D feature vectors (containing the standard deviation
%             and the convolution ratio) for N observations 

%% 1 - Reshape data size
data = reshape(data,size(data,1),3,size(data,2)/3);
L = size(data,3);

%% 2 - Define a Gaussian filter of legth 0.5ms
dt = 1.5262e-5;
G_length = round(0.5e-3/dt);
gaussFilter = gausswin(G_length)';
gaussFilter = gaussFilter / sum(gaussFilter); % normalize

%% 3 - Loop over all training data
for i = 1:size(data,1)
    signal = squeeze(data(i,:,:));
    if isempty(signal)
        warning('Empty signal')
    else

        %% 3.1 - Calculate the standard deviation of the signal
        std_a1(i) = std(signal(1,:));
        std_a2(i) = std(signal(2,:));
        std_a3(i) = std(signal(3,:));
        mean_std(i) = mean([std_a1(i), std_a2(i), std_a3(i)]);

        %% 3.2 - Find the convolution maximum amplitude over median

        % 3.2.1 - Find the convolved signal using a Gaussian filter
        filtered_a1 = conv(signal(1,:), gaussFilter, 'same');
        filtered_a2 = conv(signal(2,:), gaussFilter, 'same');
        filtered_a3 = conv(signal(3,:), gaussFilter, 'same');

        % 3.2.2 - Find the median of the convolution amplitude
        median1 = median(abs(filtered_a1));
        median2 = median(abs(filtered_a2));
        median3 = median(abs(filtered_a3));

        % 3.2.3 - Find the convolution maximum amplitude over median
        max_conv_a1(i) = log10(abs(max(filtered_a1)/median1));
        max_conv_a2(i) = log10(abs(max(filtered_a2)/median2));
        max_conv_a3(i) = log10(abs(max(filtered_a3)/median3));

        % 3.2.4 - Find the convolution minimum amplitude over median
        min_conv_a1(i) = log10(abs(min(filtered_a1)/median1));
        min_conv_a2(i) = log10(abs(min(filtered_a2)/median2));
        min_conv_a3(i) = log10(abs(min(filtered_a3)/median3));

        % 3.2.5 - Assign the maximum (max/min) amplitude over median to array
        max_conv(i) = max([max_conv_a1(i), max_conv_a2(i), max_conv_a3(i), min_conv_a1(i), min_conv_a2(i), min_conv_a3(i)]);
    end
end

features = [mean_std' max_conv'];
end
