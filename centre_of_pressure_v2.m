%% Calculate centre of pressure (COP)

load('COP_data.mat')
stimulus_length = 35.0; % in mm
sr = 1000; % sample rate in Hz
td = 7; % trial duration in s





Mxh = D.S2Tx + D.S2Fy * 0.01;% Distance in m between top plate surface and centre of force senor 
Myh = D.S2Ty + D.S2Fx * 0.01; 

copX = Myh./D.S2Fz;
copY = Mxh./D.S2Fz; 

%copTan = sqrt(copX^2 + copY^2)^2; 

figure
plot(copX(1:4000),copY(1:4000))
hold on
plot(copX(4001:end),copY(4001:end),'r')

figure 
plot(1/sr:1/sr:td, D.S2Fz)



