clear all;
close all;
clc;

sim_time = 8;
dT = 0.05;
Vl = 6;
Vr = 6;
Va = [Vl; Vl; Vr; Vr];

euler = @(x, x_dot, dt)x + (x_dot*dt); % Euler intergration


obstacles = [wallObject(1.2, -1, 1.2, 1), wallObject(4, -3, 4, 1), wallObject(-2, -3, 2, -3), wallObject(-3, 2, 1, 2), ];
sensor = PerfectObservationSensor(obstacles, 0.1, pi/8, 1);
% hold on
% grid on
% for i = 1:4
%     obstacles(i).inversePlot()
% end
% axis([-5,5,-5,5]);

populationSize = 10;
xi = zeros(1,24);
xi(19) = -2;
xi(20) = -1;

for i = 1:populationSize
    vehicles(i) = robot(xi, Va, 0, 0, 0, 0, dT, sim_time);
end
destination = [3.5, 2.5];

inputs = zeros(6, populationSize);

for outer_loop = 1:(sim_time/dT)

    %----------------------------------------------%
    % Run Model
    inputs(1, :) = cell2mat({vehicles.psi})*;
    
    for j = 1:length(vehicles)
        V = sensor.detect(vehicles(j).xx, vehicles(j).y, vehicles(j).psi);
        vehicles(j).update(V, euler)
    end


    %----------------------------------------------%
    
end
fprintf("Simulation Finished\n")