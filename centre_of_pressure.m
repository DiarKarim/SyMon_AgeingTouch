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
% Date: 17/11/2017
% Version: 9.0
% Contact: diarkarim@gmail.com
% Credit: Markus Rank, Satoshi Endo, ATI support team
% Ammended: 20/06/17
% Editor: Roberta Roberts; Al Loomes
%__________________________________________________________________________

% Clean up
clear all; clf; clc

td = 7;
fs = 1000;
offtd = 1; %n Trial duration for offset recording
x = 1;
nTrials = 0;

%% 2. Initialize the ATI data acquisition device
initialise_ATI();

set(aiGRIP2,'SamplesPerTrigger',td*RateGRIP);
%end

% %% 4. Create audio objects
% load('whiteNoise.mat')
% volumeParameter = 15; % This parameter defines the volume of the white noise sound. It is inversely correlated to the volume.
% whiteNoise2 = whiteNoise/volumeParameter;
% audioWhite = audioplayer(whiteNoise2,whiteFreq);
% load('hearBeats4.mat')
% audioObject = audioplayer(snd, freqz);
%
set(aiGRIP2,'InputType','Differential');
set(aiGRIP2.Channel,'InputRange',[-10 10]);
addchannel(aiGRIP2, 0:5); % 2:2
addline(dioGRIP2,0,'in');
% % %% calibrate force data
S2 = ati_15514_read( 'C:\Documents and Settings\Administrator\Desktop\ATI_Force_Sensor_Calibration_Files\FT15575\Calibration\FT15575.cal'); %originally FT5346

%timepoint = 1/fs:1/fs:td;

%% 5. Get initial offset (make sure force sensor is not touched at this point)
% Start Force Device
display ('Don''t touch the force plate!')
start(aiGRIP2);
%pause(2)
input ('Press Enter when ready')

% Get initial offset (make sure no forces are applied to the sensor)
tic
while offtd >= toc
    initOffset(x,:) = getsample(aiGRIP2);
    normOff(x,:) = ((initOffset(x,:)*S2(3,1:6)')./S2(3,7));
    x = x+1;
end
initoff = nanmean(normOff);

%% 6. Main recording loop
%     start(aiGRIP2);
%     pause(0.5)

beep;
[dataGRIP2, time] = getdata(aiGRIP2);
beep;

sig2 = ([dataGRIP2(:,1) dataGRIP2(:,2) dataGRIP2(:,3) dataGRIP2(:,4) dataGRIP2(:,5) dataGRIP2(:,6)]);

%% apply calibration matrix to force/toque sensors
D.S2Fx = (sig2*S2(1,1:6)')./S2(1,7);%FT12466 middle
D.S2Fy = (sig2*S2(2,1:6)')./S2(2,7);
D.S2Fz = (sig2*S2(3,1:6)')./S2(3,7); % This is the force downwards
D.S2Tx = (sig2*S2(4,1:6)')./S2(4,7)+D.S2Fy(1,:)*S2(7,3);
D.S2Ty = (sig2*S2(5,1:6)')./S2(5,7)-D.S2Fx(1,:)*S2(7,3);
D.S2Tz = (sig2*S2(6,1:6)')./S2(6,7);

% Correct zero offset
normalOffset = nanmean(D.S2Fz(1:10));
normalForce = D.S2Fz - normalOffset;
normalForce = sqrt(normalForce.^2);

OffsetT = nanmean(D.S2Fy(1:10));
TangentialForce = D.S2Fy - OffsetT;
TangentialForce = sqrt(TangentialForce.^2);

%plot(D.S2Fz); hold on;
plot(normalForce,'r')
hold on
plot(TangentialForce, 'g')
legend('Corrected Force Reading')
hold off

%SAVE

cd('C:\Documents and Settings\Administrator\Desktop\CentreOfPressure_Diar')
saveFName = 'COP_data'; % Centre of pressure data
save(saveFName,'D','normalForce') %,'pairOrder','placementOrder')

stop(aiGRIP2)





