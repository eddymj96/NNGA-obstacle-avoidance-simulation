
%----------------------------------------------%
% Workspace Clear up
close all;
clear all;
clc;
%----------------------------------------------%

%----------------------------------------------%
% Setup Simulation
Vl = 6;
Vr = 6;
sim_time = 3;
dT = 0.05;
xi = zeros(1,24); % intial state for x
LeftS = 0;
RightS = 0;
%----------------------------------------------%

%----------------------------------------------%
% Create Environment
max_x = 10;
max_y = 10;

Obs_Matrix = zeros(max_x/0.01,max_y/0.01);

wall = wallObject(-1, 1.2,1,1.2);
wall2 = wallObject(-3, -2, -3, 2);

% for x=1:length(wall)
%     
%     xpos = (wall(x,1)/0.01)+((max_x/2)/0.01);
%     ypos = (wall(x,2)/0.01)+((max_y/2)/0.01);
%     
%     Obs_Matrix(ypos,xpos) = 1;
% end
% 
% for x=1:length(wall2)
%     
%     xpos = (wall2(x,1)/0.01)+((max_x/2)/0.01);
%     ypos = (wall2(x,2)/0.01)+((max_y/2)/0.01);
%     
%     Obs_Matrix(ypos,xpos) = 1;
% end
%----------------------------------------------%

%----------------------------------------------%
euler = @(x, x_dot, dt)x + (x_dot*dt); % Euler intergration
Va = [Vl; Vl; Vr; Vr];
vehicle = robot(xi, Va, 0, 0, 0, 0, dT, sim_time);
for outer_loop = 1:(sim_time/dT)

    %----------------------------------------------%
    % Run Model

    [xdot, xi] = full_mdl_motors(Va,xi,0,0,0,0,dT);  
    vehicle.update(euler)
        xi = xi + (xdot*dT); % Euler intergration
    % Store varibles
        xdo(outer_loop,:) = xdot;
        xio(outer_loop,:) = xi;
    %----------------------------------------------%
    
    %----------------------------------------------%
    figure(1);
    clf; hold on; grid on; axis([-5,5,-5,5]);
    drawrobot(0.2,vehicle.y,vehicle.xx, vehicle.psi,'b');
    xlabel('y, m'); ylabel('x, m');
    wall.plot();
    wall2.plot();
    pause(0.001);
    %----------------------------------------------%
    
end
%----------------------------------------------%

%----------------------------------------------%
%Plot Variables
figure(2); plot(xio(:,20),xio(:,19));
figure(3); plot(xio(:,19));
figure(4); plot(xio(:,24));
%----------------------------------------------%