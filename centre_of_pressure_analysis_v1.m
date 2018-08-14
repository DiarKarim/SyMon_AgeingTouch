%% Centre of pressure (COP)
% Program to calculate and verfy (via optical motion capture) the centre of
% pressure from a 6DOF ATI force sensor mounted on a rigid metal plate
% 
% The formula used for the cop calculation is as follows: 
%   x_cop = ((Fx * p_dist) + Ty) / Fz
%   y_cop = ((Fy * p_dist) + Tx) / Fz
%
%
%% Load data
% e.g.: 


function centre_of_pressure_analysis_v1

load('COP_smooth_03.mat')

%% Display data 
x_pts = 1:length(dat_pos); % Data points
t = time; 
p_dist = 13.26; % Distance between centre of force sensor and force plate in mm

figure
ax = plot(x_pts,D.S2Fz.*100,'m',x_pts,dat_pos(:,1),'r');
hold on
plot(x_pts,dat_pos(:,2),'g');
plot(x_pts,dat_pos(:,3),'b');
legend('Z-force','X-pos','Y-pos','Z-pos');
xlabel('Time/ s')
ylabel('Position/ mm')

xt = getpts; % Contact time points 

figure 
plot3(dat_pos(:,1),dat_pos(:,2),dat_pos(:,3),'r-'); % Show finger trajectory 

%% Velocity POSITION data
x_pos1 = dat_pos(xt(1):xt(2),1);
x_pos2 = dat_pos(xt(3):xt(4),1);
x_pos3 = dat_pos(xt(5):xt(6),1);
x_pos4 = dat_pos(xt(7):xt(8),1);
x_pos5 = dat_pos(xt(9):xt(10),1);
x_pos6 = dat_pos(xt(11):xt(12),1);




y_pos = dat_pos(xt([1 3 5]):xt([2 4 6]),2);
%z_pos = dat_pos(xt(1):xt(2),3);
tan_pos = sqrt(x_pos.^2 + y_pos.^2);

% Contact duration
abs_dur = t(xt(1):xt(2)); % Absolute contact duration
cnt_dur = abs_dur(end) - abs_dur(1);% Relative contact duration

% Finger velocity
distce = tan_pos(end)-tan_pos(1);
fing_vel = distce/cnt_dur; % In mm per second

%% Velocity FORCE data
x_cop = ((D.S2Fx * p_dist) + D.S2Ty)./D.S2Fz;
y_cop = ((D.S2Fy * p_dist) + D.S2Tx)./D.S2Fz;

plot(x_cop,'r');
hold on
plot(y_cop,'g');

x_fdist = abs(min(x_cop(xt(1):xt(2)))-max(x_cop(xt(1):xt(2))));
y_fdist = abs(min(y_cop(xt(1):xt(2))-max(y_cop(xt(1):xt(2)))));

figure 
plot(x_fdist, y_fdist,'b');

tan_frc = sqrt(x_fdist.^2 + y_fdist.^2);

frc_vel = tan_frc/cnt_dur;

%% Show results 
disp('Actual velocity    Force Computed Velocity')
disp([fing_vel frc_vel]);

keyboard


