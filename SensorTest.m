clc;
clear all;
clf;
obstacle = wallObject(5*rand(1 , 1), 5*rand(1 , 1),8*rand(1 , 1), 8*rand(1 , 1));
%obstacle = wallObject(-3, 2.95, 4.375052153639871, 2.95);
sensor = PerfectObservationSensor(obstacle, 0, pi/8, 3);

% Generating old sensor and inputs
max_x = 10;
max_y = 10;

Obs_Matrix = zeros(max_x/0.01,max_y/0.01);

wall = WallGeneration1(-1, 1,1.2,1.2,'h');

for x=1:length(wall)
    
    xpos = (wall(x,1)/0.01)+((max_x/2)/0.01);
    ypos = (wall(x,2)/0.01)+((max_y/2)/0.01);
    
    Obs_Matrix(ypos,xpos) = 1;
end

% Running both sensors, comparing output values and runtime efficiency
hold on
% Use tic toc functions to time, and for loop to have large sample set
sensor.detect(0, 0, pi/3)
sensorout = ObsSensor1(0, 0, 0, pi/3, Obs_Matrix);

t = 0:2*pi/100:2*pi;

plot(sensor.d_limit*cos(t), sensor.d_limit*sin(t))

% x0 = [-1,1]; % Make a starting guess at the solution
% options = optimoptions(@fmincon,'Algorithm','sqp');
% 
% A = [1, 2; 1, -2];
% b = [0;0];
% 
% Aeq = [1, 3];
% beq = [1];


line([0,  sensor.d_limit*cos(pi/2)],[0, sensor.d_limit*sin(pi/2)]);
line([0,  sensor.d_limit*cos(sensor.alpha + pi/2)],[0, sensor.d_limit*sin(sensor.alpha + pi/2)]);
line([0,  sensor.d_limit*cos(-sensor.alpha + pi/2)],[0, sensor.d_limit*sin(-sensor.alpha + pi/2)]);

axis equal

