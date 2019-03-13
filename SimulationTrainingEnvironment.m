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

populationSize = 20;
breedingSize = 4;
generations = 5;
xi = zeros(1,24);
xi(19) = -2;
xi(20) = -1;

fun = @(inputs, weights)sigmf(sum(inputs.*weights), [1,1]);
layerArray = [7, 5, 3, 2]; 



for i = 1:populationSize
    vehicles(i) = robot(xi, Va, 0, 0, 0, 0, dT, sim_time);
    NeuralNets(i) = NeuralNet(layerArray, @perceptron, fun);
end
destination = [3.5, 2.5];

inputs = zeros(7, populationSize);

%for j = 1:generations 


    for outer_loop = 1:(sim_time/dT)

        %----------------------------------------------%
        % Run Model

        inputs(1, :) = cell2mat({vehicles.psi}) - atan((cell2mat({vehicles.y}) - 2.5)./ (cell2mat({vehicles.xx}) - 3.5));
        inputs(2, :) = sqrt((cell2mat({vehicles.y}) - 2.5).^2 + (cell2mat({vehicles.xx}) - 3.5).^2);



        for j = 1:length(vehicles)

            inputs(3, j) = sqrt(vehicles(j).xdot(20)^2 + vehicles(j).xdot(19)^2);
            inputs(4, j) = sqrt(vehicles(j).xdot(13)^2 + vehicles(j).xdot(14)^2);
            inputs(5, j) = vehicles(j).xdot(14);
            V = sensor.detect(vehicles(j).xx, vehicles(j).y, vehicles(j).psi);
            inputs(6, j) = V(1);
            inputs(7, j) = V(2);
            output = 15*(0.5-NeuralNets(j).resolve(inputs(:, j)'));
            vehicles(j).update(output', euler);
        end

        %----------------------------------------------%

    end

%end
hold on; grid on; axis([-5,5,-5,5]);
for k = 1:length(vehicles)
	figure(1); plot(vehicles(k).x_matrix(20, :),vehicles(k).x_matrix(19, :)); xlabel('y, m'); ylabel('x, m');
end
for m = 1:length(obstacles)
    obstacles(m).inversePlot();
end
plot(destination(1), destination(2), '*')


fprintf("Simulation Finished\n")

function sorted =  fitnessAlgorithm(neuralNets, vehicles, point, collisions)
    
    x = vehicles.xx - point(1);
    y = vehicles.y - point(2);
    
    distances = sqrt(x.^2 + y.^2);
    
    [~, ind] = sort([vehicles]);
    chairs_sorted = NeuralNets(ind);
    
    distances = vehicles ;
    [~, ind] = sort([vehicles]);
end

function collisionResult = collisionCheck(obstacles, vehicles)
    a = -([obstacles.starting_y] - [obstacles.end_y]);
    b = ([obstacles.starting_x] - [obstacles.end_x]);
    c = [obstacles.starting_y] + (a./b).*[obstacles.starting_x];
    
    d = abs(a.*[vehicles.xx] + b.*[vehicles.y] + c)/sqrt(a.^2 + b.^2);
    lineCollisions = (d < 0.1);
    collisions = lineCollisions*
    
     if vehicles.x
end
