%% Friction Measurement
% This script reads voltages from an ATI F/T sensor in a loop and applies
% a calibration matrix to those voltages to convert the values into forces.
%
% The processing steps of this script are:
%   1. Load File
%   2. Initialize the ATI data acquisition device
%   3. Create audio objects
%   4. Get initial offset (make sure force sensor is not touched)
%   5. Main recording loop (Recorded data is saved at the end of this loop)
%
% Author: Diar Karim, Al Loomes
% Date: 04/12/2017
% Version: 4.0
% Contact: diarkarim@gmail.com
% Credit: Markus Rank, Satoshi Endo, ATI support team, Qualisys support
% Ammended: 20/06/17
% Editor: Roberta Roberts; Al Loomes
%__________________________________________________________________________

% Clean up
clear all; clf; clc

%fnum = input('Type filne number: ');

q = QMC; % Qualisys object

td = 7;
fs = 1000;
offtd = 1; %n Trial duration for offset recording
x = 1;
k = 1;
nTrials = 0;
numTrial = 5;

%% 2. Initialize the ATI data acquisition device
s = daq.createSession('ni');
addAnalogInputChannel(s,'Dev9', 0:5, 'Voltage');
s.Rate = fs;
s.DurationInSeconds = td;

% tic
% while toc < td
%     data(x,:) = s.inputSingleScan;
%     x = x+1;
% end

for trN = 1:numTrial
    
    beep; pause(0.75); beep;
    tic
    while toc < td
        
        dat_pos(k,:) = QMC(q);
        dat_frc(k,:) = s.inputSingleScan;
        
        k=k+1;
    end
    beep; pause(1);
    
    frc_sf = length(dat_frc)/td;
    time = 1/frc_sf:1/frc_sf:td;
    
    %[dat_frc,time] = s.startForeground;
    plot(time, dat_frc);
    xlabel('Time (secs)');
    ylabel('Voltage')
    
    
    
    %% Calibrate force
    
    % Load calibration file
    S2 = ati_15514_read( 'C:\Users\AbdlkarD\Dropbox\CentreOfPressure_Diar\ATI_Calib_Files\FT15575.cal');
    
    % Rearrange force matrix
    sig2 = ([dat_frc(:,1) dat_frc(:,2) dat_frc(:,3) dat_frc(:,4) dat_frc(:,5) dat_frc(:,6)]);
    
    % Apply calibration matrix to force/toque sensor data
    D.S2Fx = (sig2*S2(1,1:6)')./S2(1,7);
    D.S2Fy = (sig2*S2(2,1:6)')./S2(2,7);
    D.S2Fz = (sig2*S2(3,1:6)')./S2(3,7); % This is the normal force
    D.S2Tx = (sig2*S2(4,1:6)')./S2(4,7)+D.S2Fy(1,:)*S2(7,3);
    D.S2Ty = (sig2*S2(5,1:6)')./S2(5,7)-D.S2Fx(1,:)*S2(7,3);
    D.S2Tz = (sig2*S2(6,1:6)')./S2(6,7);
    
    raw_force_voltage = sig2;
    
    %% Save data
    fnum = trN;
    cd('C:\Users\AbdlkarD\Dropbox\CentreOfPressure_Diar')
    savefnum = sprintf('COP_smooth_%02d',fnum); % Centre of pressure data
    save(savefnum,'D','dat_pos','time','raw_force_voltage') %,'pairOrder','placementOrder')
    
end

QMC(q,'disconnect')



