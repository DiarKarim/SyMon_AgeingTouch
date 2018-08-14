% Initialise National Instruments force sensors
% %% Create object for data acquisition
dqinfo =  daqhwinfo('nidaq');
devchannel = strcmp('USB-6229',dqinfo.BoardNames)==1;
%devchannel = strcmp('USB-6229',dqinfo.BoardNames)==1;
%devchannel = strcmp('USB-6343','Dev9');

% Initial NI device 1/3 (Index finger sensor)
aiGRIP2 = analoginput('nidaq', cell2mat(dqinfo.InstalledBoardIds(1)));
dioGRIP2 = digitalio('nidaq', cell2mat(dqinfo.InstalledBoardIds(1)));
% aiGRIP2 = analoginput('nidaq', dqinfo.InstalledBoardIds{devchannel(1)});
% dioGRIP2 = digitalio('nidaq', dqinfo.InstalledBoardIds{devchannel(1)});
RateGRIP = setverify(aiGRIP2,'SampleRate',fs);

% %% calibrate force data
S2 = ati_15514_read( 'C:\Documents and Settings\Administrator\Desktop\ATI_Force_Sensor_Calibration_Files\FT15575\Calibration\FT15575.cal');
