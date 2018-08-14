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


function scanVelocity(fileNum)

load(sprintf('COP_smooth_%02d.mat',fileNum))

% Loop variables:
x_pts = 1:length(dat_pos); % Data points
t = time; 
p_dist = 15; % Distance between centre of force sensor and force plate in mm
td = 7;
sf = length(dat_pos)/td; 

% Zero position vector 
dat_pos(:,1) = dat_pos(:,1)-dat_pos(1,1);
dat_pos(:,2) = dat_pos(:,2)-dat_pos(1,2);
dat_pos(:,3) = dat_pos(:,3)-dat_pos(1,3);

%% Display data 
figure
ax = plot(x_pts,D.S2Fz.*100,'m',x_pts,dat_pos(:,1),'r');
hold on
plot(x_pts,dat_pos(:,2),'g');
plot(x_pts,dat_pos(:,3),'b');
legend('Z-force','X-pos','Y-pos','Z-pos');
xlabel('Time/ s')
ylabel('Position/ mm')

xt = getpts; % Contact time points 

figure; plot3(dat_pos(:,1),dat_pos(:,2),dat_pos(:,3)); % Show finger trajectory 

%% Velocity POSITION data
x_pos = dat_pos(xt(1):xt(2),1);
y_pos = dat_pos(xt(1):xt(2),2);
%z_pos = dat_pos(xt(1):xt(2),3);
tan_pos = sqrt(x_pos.^2 + y_pos.^2);

figure
plot(smooth(tan_pos),'m')
velx = diff(smooth(tan_pos))./(1/sf);
plot(velx,'r')

% Contact duration
abs_dur = t(xt(1):xt(2)); % Absolute contact duration
cnt_dur = abs_dur(end) - abs_dur(1);% Relative contact duration

% Finger velocity
distce = tan_pos(end)-tan_pos(1); % In mm
fing_vel = distce/cnt_dur; % In mm per second




%% Velocity FORCE data

% Zero force and torque vectors
Fx = D.S2Fx - D.S2Fx(1);
Fy = D.S2Fy - D.S2Fy(1);
Fz = D.S2Fz - D.S2Fz(1); 
Tx = D.S2Tx - D.S2Tx(1); 
Ty = D.S2Ty - D.S2Ty(1); 

% Apply COP formula
x_cop = ((Fx * p_dist) + Ty)./Fz;
y_cop = ((Fy * p_dist) + Tx)./Fz;

plot(x_cop,'r');
hold on
plot(y_cop,'g');

x_fdist = abs(min(x_cop(xt(1):xt(2)))-max(x_cop(xt(1):xt(2))));
y_fdist = abs(min(y_cop(xt(1):xt(2))-max(y_cop(xt(1):xt(2)))));

tan_frc = sqrt(x_fdist.^2 + y_fdist.^2);

frc_vel = tan_frc/cnt_dur;

%% Show results 
disp(' ')
disp('Actual velocity: ');
disp(fing_vel); disp('mm/s');
disp('Force velocity: ');
disp(frc_vel); disp('mm/s');

keyboard

