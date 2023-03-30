%%% This script classifies the triggered waveforms acquired on 16.12.2021
%% 1 - Load the trained CNN (model_run_GitHub)
CNN = importTensorFlowNetwork('model_run_GitHub');

%% 2 - Load a sample .cdf file containing all triggered snapshot waveforms
file = dir('solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf');

%% 3 - Classify the triggered snapshots in file using the loaded CNN

% 3.1 Define path to load file from
datapath = '/Users/akv020/Projects/ML classification of dust/GitHub/MatLab_code_cdf_classificaiton';

% 3.2 Use the function "classify_file.m" to classify the snapshoths in file
[labels_CNN,~,~,~,max_amplitude] = classify_file(file.name,datapath,CNN);

% 3.3 Get number of dust impacts and the impact index from the results
number_of_dust = sum(labels_CNN);
index_of_dust = find(labels_CNN==1);
signal_preprocessed = preprocess_cdf(file.name,4,datapath);
signals = [signal_preprocessed{1}; signal_preprocessed{2}];
time_steps = linspace(0,62.5,size(signals,2));

%% 4 - Plot the signals classified as "dust" by the CNN
FIG = figure('units','centimeters','position',[1,1,36.0,36.0]);
sx = 0.08;
sy = 0.08;
fz = 18;
lw = 3;

rows = floor(number_of_dust/3);
for i = 1:number_of_dust
    dust_idx = index_of_dust(i);
    signal = squeeze(signals(dust_idx,:,:));

    subplot_tight(rows,3,i,[sx,sy])
    plot(time_steps,signal(:,2),'k')
    if i > number_of_dust - 3
        xlabel('Time [ms]')
    end
    ylabel('E-field [a.u.]')
    title(['Max amplitude: ',num2str(round(max_amplitude(dust_idx)*1000,2)),'mV']);
    ylim([-1.05 1.05])
    grid on
end
