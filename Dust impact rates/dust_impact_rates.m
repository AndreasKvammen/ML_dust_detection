%%% This script calculates the TDS, SVM and CNN dust impact rates 

%% 1 - Read Dust Count Data
TDS_data = readtable('TDS_ddc.txt');
SVM_data = readtable('SVM_ddc.txt');
CNN_data = readtable('CNN_ddc.txt');

TDS_ddc = TDS_data.daily_dust_count;
SVM_ddc = SVM_data.daily_dust_count;
CNN_ddc = CNN_data.daily_dust_count;

%% 2 - Read TDS, SVM and CNN fit data (with eq. from Zaslavsky et al. (2021))
fit_data = readtable('fits'); 
dcycle = fit_data.dutyCycle_day_;
TDS_fit = fit_data.tds_fit__day_;
SVM_fit = fit_data.svm_fit__day_;
CNN_fit = fit_data.cnn_fit__day_;

% Read time data and convert ti datetime format 
fit_years = fit_data.year;
fit_months = fit_data.month;
fit_days = fit_data.day;
days_plot = datetime(fit_years,fit_months,fit_days);

%% 3 - Read the RPW-TDS duty cycle data if correct mode is used (non nans)
numdays = length(CNN_ddc); % days with data

% Loop over all days
j = 1; 
for i = 1:numdays
    number = CNN_ddc(i); % daily dust count (DDC) number 
    if ~isnan(number)
        % if DDC is not nan, assign the duty cycle value 
        dcycle(i) = fit_data.dutyCycle_day_(j); 
        j = j + 1; 
    else
        % if DDC is nan, assign nan to duty cycle value
        dcycle(i) = nan;
    end
end

%% 4 - Convert from daily dust count to dust impact rates using duty cycle values

% Calculate medain of duty cycle values
dcm = median(dcycle(~isnan(dcycle)));

% Loop over all days
id = 1;  
for i = 1:numdays
    dc = dcycle(i);

    % Ignore days without duty cycle values 
    if isnan(dc)
        continue
    end

    % Ignore days without dust count values 
    if isnan(CNN_data.daily_dust_count(i))
        continue
    else 

        % Only consider days where the duty cycle is within 10 % of the median
        if dc < dcm*0.9 || dc < dcm*1.1

            % Convert day to datetime format
            day_str = cell2mat(CNN_data.days(i));
            day_datetime(id) = datetime([day_str(1:4),'-',day_str(6:7),'-',day_str(9:10)]);

            % Convert from daily dust count to dust impact rates using duty cycle values
            TDS_day(:,id) = TDS_data.daily_dust_count(i)/dc;
            SVM_day(:,id) = SVM_data.daily_dust_count(i)/dc;
            CNN_day(:,id) = CNN_data.daily_dust_count(i)/dc;
            id = id +1; 
        else
            % If duty cycke is not within 10 %, continue
            continue
        end
    end
end

%% 5 - Mark days at aphelion and perihelion

% Aphelion days: 10-Feb-2021   12-Sep-2021
aphelion1 = cell2mat(CNN_data.days(241));
aphelion2 = cell2mat(CNN_data.days(455));

% Perihelion days: 13-Oct-2020   03-Jun-2021
perihelion1 = cell2mat(CNN_data.days(121));
perihelion2 = cell2mat(CNN_data.days(354));

% Convert to datetime format
aphelion = [datetime([aphelion1(1:4),'-',aphelion1(6:7),'-',aphelion1(9:10)]), ...
    datetime([aphelion2(1:4),'-',aphelion2(6:7),'-',aphelion2(9:10)])];
perihelion = [datetime([perihelion1(1:4),'-',perihelion1(6:7),'-',perihelion1(9:10)]), ...
    datetime([perihelion2(1:4),'-',perihelion2(6:7),'-',perihelion2(9:10)])];

%% 6 - Plot the dust impact rates and the fit to the data 

% Define figure properities 
FIG = figure('units','centimeters','position',[1,1,24.0,36.0]);
sx = 0.07; 
sy = 0.08;
fz = 14; 
mkz = 50; 
mz = 5; 
lw = 3; 
lwr = 2;
ystart = 0; 
ystop = 700; 

% Plot TDS dust detction rates and fit 
subplot_tight(4,1,1,[sx sy])
hold on
scatter(day_datetime,TDS_day,mkz,'black','filled')
xlim([datetime('4-Jul-2020'); datetime('17-Dec-2021')])
ylim([ystart ystop]) 
plot([aphelion(1), aphelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([aphelion(2), aphelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([perihelion(1), perihelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
plot([perihelion(2), perihelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
a = plot(TDS_fit,'color',[0 0.4470 0.7410],'LineWidth',lw);
xticks(datetime('Aug-2020') : calmonths(3) : datetime('Dec-2021'))
title('a) TDS Dust Impacts 4205')
ylabel('Impact Rate [/day]')
legend(a,'Fit to TDS Detections')
grid on

% Plot SVM dust detction rates and fit 
subplot_tight(4,1,2,[sx sy])
hold on
scatter(day_datetime,SVM_day,mkz,'black','filled')
xlim([datetime('4-Jul-2020'); datetime('17-Dec-2021')])
ylim([ystart ystop])
plot([aphelion(1), aphelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([aphelion(2), aphelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([perihelion(1), perihelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
plot([perihelion(2), perihelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
b = plot(SVM_fit,'color',[0.6350 0.0780 0.1840],'LineWidth',lw);
xticks(datetime('Aug-2020') : calmonths(3) : datetime('Dec-2021'))
title('b) SVM Dust Impacts 4818 \pm 52')
ylabel('Impact Rate [/day]')
legend(b,'Fit to SVM Detections')
grid on

% Plot CNN dust detction rates and fit 
subplot_tight(4,1,3,[sx sy])
hold on
scatter(day_datetime,CNN_day,mkz,'black','filled')
xlim([datetime('4-Jul-2020'); datetime('17-Dec-2021')])
ylim([ystart ystop])
plot([aphelion(1), aphelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([aphelion(2), aphelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([perihelion(1), perihelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
plot([perihelion(2), perihelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
c = plot(CNN_fit,'color',[0.4660 0.6740 0.1880],'LineWidth',lw);
xticks(datetime('Aug-2020') : calmonths(3) : datetime('Dec-2021'))
title('c) CNN Dust Impacts 4886 \pm 298')
ylabel('Impact Rate [/day]')
legend(c,'Fit to CNN Detections')
grid on

% Compare the TDS, SVM and CNN fits  
subplot_tight(4,1,4,[sx sy])
hold on
plot([aphelion(1), aphelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([aphelion(2), aphelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',lwr)
plot([perihelion(1), perihelion(1)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
plot([perihelion(2), perihelion(2)],[ystart ystop],'color',[0.4 0.4 0.4],'LineStyle','-','LineWidth',lwr)
a = plot(days_plot,TDS_fit,'color',[0 0.4470 0.7410],'LineWidth',lw);
b = plot(days_plot,SVM_fit,'color',[0.6350 0.0780 0.1840],'LineWidth',lw);
c = plot(days_plot,CNN_fit,'color',[0.4660 0.6740 0.1880],'LineWidth',lw);
xlim([datetime('4-Jul-2020'); datetime('17-Dec-2021')])
ylim([ystart ystop])
xticks(datetime('Aug-2020') : calmonths(3) : datetime('Dec-2021'))
title('d) TDS, SVM, CNN Compared')
legend([a, b, c],{'TDS Fit','SVM Fit','CNN Fit'})
ylabel('Impact Rate [/day]')
grid on