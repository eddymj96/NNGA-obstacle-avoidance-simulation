
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
sim_time = 5;
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

wall = WallGeneration1(-1, 1,1.2,1.2,'h');
wall2 = WallGeneration1(-3, -3, -2, 2,'v');
FLController = readfis('FLController'); %

for x=1:length(wall)
    
    xpos = (wall(x,1)/0.01)+((max_x/2)/0.01);
    ypos = (wall(x,2)/0.01)+((max_y/2)/0.01);
    
    Obs_Matrix(ypos,xpos) = 1;
end

for x=1:length(wall2)
    
    xpos = (wall2(x,1)/0.01)+((max_x/2)/0.01);
    ypos = (wall2(x,2)/0.01)+((max_y/2)/0.01);
    
    Obs_Matrix(ypos,xpos) = 1;
end
%----------------------------------------------%

%----------------------------------------------%

for outer_loop = 1:(sim_time/dT)

    %----------------------------------------------%
    % Run Model

    

    sensorOut = ObsSensor1(xi(19),xi(20),[0.2 0],xi(24),Obs_Matrix);
    %Vl = sensorOut(1)*10 - 5.3;
    %Vr = sensorOut(1)*10 - 3;
    

    %Va(1:2) = sensorOut(1);
    %Va(3:4) = sensorOut(2);
    w1 = 3;
    w2 = 6;
    w3 = -3;
    w4 = -2;
    Vl = (sensorOut(1)*w1 + sensorOut(2)*w3);
    Vr = (sensorOut(1)*w2 + sensorOut(2)*w4);
    
    Va = [Vl; Vl; Vr; Vr];
    [xdot, xi] = full_mdl_motors(Va,xi,0,0,0,0,dT);   
    xi = xi + (xdot*dT); % Euler intergration
    
    % Store varibles
    xdo(outer_loop,:) = xdot;
    xio(outer_loop,:) = xi;
    %----------------------------------------------%
    
    %----------------------------------------------%
    figure(1);
    clf; hold on; grid on; axis([-5,5,-5,5]);
    
    daspect([1 1 1]);
    drawrobot(0.2,xi(20),xi(19),xi(24),'b');
    xlabel('y, m'); ylabel('x, m');
    plot(wall(:,1),wall(:,2),'k-');
    plot(wall2(:,1),wall2(:,2),'k-');
    %pause(0.001);

    


    %----------------------------------------------%
    
end
%----------------------------------------------%

%----------------------------------------------%
%Plot Variables
time = 0+dT:dT:sim_time;
figure(2); plot(xio(:,20),xio(:,19)); xlabel('y, m'); ylabel('x, m'); title('x-y distance plot')
figure(3); plot(time, xio(:,19)); ylabel('x, m');xlabel('time, s'); title('x distance plot')
figure(4); plot(time,xio(:,24));ylabel('psi, rad');xlabel('time, s');title('psi (Heading) plot') 
figure(5);

clf; hold on; grid on; axis([-5,5,-5,5]);
    
daspect([1 1 1]);
drawrobot(0.2,xi(20),xi(19),xi(24),'b');
xlabel('y, m'); ylabel('x, m');
plot(wall(:,1),wall(:,2),'k-');
plot(wall2(:,1),wall2(:,2),'k-');
plot(xio(:,20),xio(:,19))
%----------------------------------------------%