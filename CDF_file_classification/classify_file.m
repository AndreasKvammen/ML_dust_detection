function [labels, dust_labels, nodust_labels, quality_factors, max_amplitude] = classify_file(filename,datapath,net)
%%% This function reads data in filename and classifies it with input "net"
%
% Input:
% filename    = [string] name of file to read (e.g: solo_L2_rpw-tds-surv-rswf-e_20200820_V03.cdf)
% datapath    = [string] name of folder containing the .cdf files
% net         = [DAGNetwork] CNN classifier (imported from tensorflow)
%
% Output:
% labels         = [array] labels of events flagged as (dust/other/regular) in filename
%                          1 = dust
%                          0 = no dust
% dust_labels    = [array] labels of events flagged as dust in filename
% other_labels   = [array] labels of events flagged as other in filename

%% 1 - Read data in file and process for cnn classification
compression = 4;
[signal_preprocessed,Q,max_amp] = preprocess_cdf(filename,compression,datapath);

%% 2 - Classify signals falgged as dust
nD = size(signal_preprocessed{1},1);
labels = [];
dust_labels = [];
quality_factors = [];
max_amplitude = [];
for iD = 1:nD
    class_predicted = classify(net,squeeze(signal_preprocessed{1}(iD,:,:))');
    class_predicted = grp2idx(class_predicted)-1;
    labels = [labels, class_predicted];
    dust_labels = [dust_labels, class_predicted];
    quality_factors = [quality_factors, Q{1}(iD)];
    max_amplitude = [max_amplitude, max_amp{1}(iD)];
end

%% 3 - Classify signals falgged as no dust
nN = size(signal_preprocessed{2},1);
nodust_labels = [];
for iN = 1:nN
    class_predicted = classify(net,squeeze(signal_preprocessed{2}(iN,:,:))');
    class_predicted = grp2idx(class_predicted)-1;
    labels = [labels, class_predicted];
    nodust_labels = [nodust_labels, class_predicted];
    quality_factors = [quality_factors, Q{2}(iN)];
    max_amplitude = [max_amplitude, max_amp{2}(iN)];
end

end