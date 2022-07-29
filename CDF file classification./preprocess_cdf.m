function [signal_preprocessed,quality_factors,max_amplitude] = preprocess_cdf(filename,compression,datapath)
%%% This function reads data in filename and process it for classification
%
% Input:
% filename    = [string] name of file to read (e.g: solo_L2_rpw-tds-surv-rswf-e_20200820_V03.cdf)
% compression = [scalar] compression factor used for CNN (e.g. 8)
% datapath    = [string] name of folder containing the .cdf files
%
% Output:
% signal_preprocessed    = [cell] Cell of data containing signal_preprocessed:
% signal_preprocessed{1} = dust_signals [3xNDxNO] or []
% signal_preprocessed{2} = nodust_signals [3xNDxNO] or []
%                          3  = Chanels (antennas)
%                          ND = Number of Data points: ND = 16384/compression
%                          NO = Number of Observations flagged as (dust/nodust)
%                         [] = Empty (no observations)
%
% quality_factors        = [cell] Cell of data containing quality_factors:
% quality_factors{1}     = Q (65535) of dust dust_signals [1xNO] or []
% quality_factors{2}     = Q of no dust dust_signals [1xNO] or []
%
% max_amplitude          = [cell]  Cell of max signal amplitudes in mV
% max_amplitude{1}       = dust signal amplitudes[1xNO] or []
% max_amplitude{2}       = no dust signal amplitudes [1xNO] or []

%% 1 - Read data
try
    file = dir(fullfile(datapath,filename));
    [data,info] = spdfcdfread(fullfile(datapath,filename));
    software_version = cell2mat(info.GlobalAttributes.Software_version);
    mode = file.name(22:25);
catch
    warning(['Unable to read file: ', filename,' From folder: ',datapath])
end

%% 2 - Define data index array
dust = [];
nodust = [];

%% 3 - Check software version
if strcmp(software_version,'2.1.1')
    %if sum(strcmp(software_version,{'2.1.1','2.1.0'})) % Changed for additional data (cdag)

    %% 4 - Check operation mode (tswf/rswf)
    if strcmp(mode,'tswf')

        %% 5 - Get data indeces
        for i1 = 1:length(info.Variables)

            % Quality factor
            if strcmp(info.Variables{i1,1},'QUALITY_FACT')
                index_Q = i1;
            end

            % Epoch
            if strcmp(info.Variables{i1,1},'Epoch')
                index_epoch = i1;
            end

            % Sampling rate
            if strcmp(info.Variables{i1,1},'SAMPLING_RATE')
                index_T = i1;
            end

            % Raw dara
            if strcmp(info.Variables{i1,1},'WAVEFORM_DATA_VOLTAGE')
                index_V = i1;
            end

            % Chanel label
            if strcmp(info.Variables{i1,1},'CHANNEL_LABEL')
                index_C = i1;
            end

            % Chanel reference
            if strcmp(info.Variables{i1,1},'CHANNEL_REF')
                index_R = i1;
            end

        end

        %% 6 - Find "dust" and "no dust" flags in monopole mode (20)
        quality_fact = data{index_Q};
        chanel_info = data{index_C};
        dust_qfactor = [];
        nodust_qfactor =[];
        for i2 = 1:length(quality_fact)
            Fs = double(data{index_T}(i2));
            L = size(data{index_V}(:,:,i2),2);
            if L ~= 16384
                warning('unsupported data size')
                continue
            elseif round(Fs/1e5,2) ~= 2.62
                warning('unsupported sampling frequency')
                continue
            end
            % Dust flag Q = 65535
            if quality_fact(i2) == 65535
                try
                    chanel_ref = data{index_R};
                    chanel3 = chanel_ref(i2,:);
                    if sum(chanel3 == 20)
                        if chanel3(3) == 20
                            dust = [dust, i2];
                            dust_qfactor = [dust_qfactor, quality_fact(i2)];
                        else
                            warning('Antenna mode: 10 20 30')
                        end
                    end
                catch
                    chanel3 = chanel_info(3,:,i2);
                    chanel3 = chanel3(~isspace(chanel3));
                    if strcmp(chanel3,'V2')
                        dust = [dust, i2];
                        dust_qfactor = [dust_qfactor, quality_fact(i2)];
                    end
                end
                % No dust flags are all other
            else
                try
                    chanel_ref = data{index_R};
                    chanel3 = chanel_ref(i2,:);
                    if sum(chanel3 == 20)
                        if chanel3(3) == 20
                            nodust = [nodust, i2];
                            nodust_qfactor = [nodust_qfactor, quality_fact(i2)];
                        else
                            warning('Antenna mode: 10 20 30')
                        end
                    end
                catch
                    chanel3 = chanel_info(3,:,i2);
                    chanel3 = chanel3(~isspace(chanel3));
                    if strcmp(chanel3,'V2')
                        nodust = [nodust, i2];
                        nodust_qfactor = [nodust_qfactor, quality_fact(i2)];
                    end
                end
            end
        end

        %% 7 - Print warning if operation mode is not tswf
    else
        warning(['Unable to recognize operation mode(tswf or rswf), current mode: ', mode])
    end

    %% 8 - Print warning if software version is not 2.1.1.
else
    warning(['Software version not 2.1.1, Software version: ',software_version])
end

%% 9 - Loop over dust signals

% Number of observations flagged as dust
ND = length(dust);
% Length of data
LD = 16384;
% Length of compressed data
LCD = round(LD/compression);
% Number of chanels
NC = 3;
dust_signals = zeros(ND,LCD,NC);
for iD = 1:ND

    % Get channel measurements
    CH1 = double(data{index_V}(1,1:LD,dust(iD)));
    CH2 = double(data{index_V}(2,1:LD,dust(iD)));
    CH3 = double(data{index_V}(3,1:LD,dust(iD)));

    % Convert to monoploe observations
    P2 = CH3;
    P1 = CH3 - CH2;
    P3 = P1  - CH1;

    % Get the maximum amplitude of the signals
    [amplitude] = max(abs([P1, P2, P3]));
    dust_amplitude(iD) = amplitude;

    % Get Sampling freuqnecy
    Fs = double(data{index_T}(dust(iD)));

    % Preprocess the monopole antenna measurements
    [A1,~] = preprocess_signal(P1,LD,compression,Fs);
    [A2,~] = preprocess_signal(P2,LD,compression,Fs);
    [A3,~] = preprocess_signal(P3,LD,compression,Fs);

    % Assign preporcessed signals to matrix
    dust_signals(iD,:,1) = A1;
    dust_signals(iD,:,2) = A2;
    dust_signals(iD,:,3) = A3;
end

%% 12 - Loop over nodust signals

% Number of observations flagged as nodust
ND = length(nodust);
% Length of data
LD = 16384;
% Length of compressed data
LCD = round(LD/compression);
% Number of chanels
NC = 3;
nodust_signals = zeros(ND,LCD,NC);
for iN = 1:length(nodust)

    % Get channel measurements
    CH1 = double(data{index_V}(1,1:16384,nodust(iN)));
    CH2 = double(data{index_V}(2,1:16384,nodust(iN)));
    CH3 = double(data{index_V}(3,1:16384,nodust(iN)));

    % Convert to monoploe observations
    P2 = CH3;
    P1 = CH3 - CH2;
    P3 = P1  - CH1;

    % Get the maximum amplitude of the signals
    [amplitude] = max(abs([P1, P2, P3]));
    nodust_amplitude(iN) = amplitude;

    % Get Sampling freuqnecy
    Fs = double(data{index_T}(nodust(iN)));

    % Preprocess the monopole antenna measurements
    [A1,~] = preprocess_signal(P1,LD,compression,Fs);
    [A2,~] = preprocess_signal(P2,LD,compression,Fs);
    [A3,~] = preprocess_signal(P3,LD,compression,Fs);

    % Assign preporcessed signals to matrix
    nodust_signals(iN,:,1) = A1;
    nodust_signals(iN,:,2) = A2;
    nodust_signals(iN,:,3) = A3;
end

%% 14 - Make output data
if ~isempty(dust)
    signal_preprocessed{1} = dust_signals;
    quality_factors{1} = dust_qfactor;
    max_amplitude{1} = dust_amplitude;
else
    signal_preprocessed{1} = [];
    quality_factors{1} = [];
    max_amplitude{1} = [];
end

if ~isempty(nodust)
    signal_preprocessed{2} = nodust_signals;
    quality_factors{2} = nodust_qfactor;
    max_amplitude{2} = nodust_amplitude;
else
    signal_preprocessed{2} = [];
    quality_factors{2} = [];
    max_amplitude{2} = [];
end