clear all;
close all;
clc;

sim_time = 10;
dT = 0.05;
Vl = 6;
Vr = 6;
Va = [Vl; Vl; Vr; Vr];

euler = @(x, x_dot, dt)x + (x_dot*dt); % Euler intergration


obstacles = [wallObject(1.2, -1, 1.2, 1), wallObject(4, -3, 4, 1), wallObject(-5, -3, 2, -3), wallObject(-3, 2, 1, 2), ];
obstacles = [wallObject(-5, -3, 2, -3)];
sensor = PerfectObservationSensor(obstacles, 0.1, pi/8, 1);
% hold on
% grid on
% for i = 1:4
%     obstacles(i).inversePlot()
% end
% axis([-5,5,-5,5]);

populationSize = 30;
breedingSize = 6;
generations = 10;
xi = zeros(1,24);
xi(19) = -2;
xi(20) = -1;

fun = @(inputs, weights)sigmf(sum(inputs.*weights), [1,1]);
fun2 = @(inputs, weights)tanh(sum(inputs.*weights));
layerArray = [5, 2]; 



for i = 1:populationSize
    NeuralNets(i) = NeuralNet(layerArray, @perceptron, fun2, []);
end
destination = [3.5, 2.5];

inputs = zeros(length(layerArray), populationSize);

for g = 1:generations 

    for i = 1:populationSize
        vehicles(i) = robot(xi, Va, 0, 0, 0, 0, dT, sim_time);
    end
    
    collisions = zeros(1, populationSize);

    for outer_loop = 1:(sim_time/dT)

        %----------------------------------------------%
        % Run Model
        headingError = cell2mat({vehicles.psi}) - atan((cell2mat({vehicles.y}) - 2.5)./ (cell2mat({vehicles.xx}) - 3.5));
        v1 = [cos([vehicles.psi])', sin([vehicles.psi])'];
        v2 = [(3.5 - [vehicles.xx])', (2.5 - [vehicles.y] )'];
        error2 = vectorAngle(v1, v2);%.*curl2D(v1, v2) + pi/2;
        inputs(1, :) = 2*error2;
        inputs(2, :) =  curl2D(v1, v2);
        inputs(3, :) = sqrt((cell2mat({vehicles.y}) - 2.5).^2 + (cell2mat({vehicles.xx}) - 3.5).^2);
        distanceError = sqrt((cell2mat({vehicles.y}) - 2.5).^2 + (cell2mat({vehicles.xx}) - 3.5).^2);
        v = v2.^2;
        error3 = sqrt(v(:, 1) + v(:, 2));
        


        for j = 1:length(vehicles)

            %inputs(3, j) = sqrt(vehicles(j).xdot(20)^2 + vehicles(j).xdot(19)^2);
            %inputs(3, j) = sqrt(vehicles(j).xdot(13)^2 + vehicles(j).xdot(14)^2);
            %inputs(3, j) = vehicles(j).xdot(14);
            V = sensor.detect(vehicles(j).xx, vehicles(j).y, vehicles(j).psi);
            inputs(4, j) = -V(1);
            inputs(5, j) = -V(2);
            output = -15*(0.5-NeuralNets(j).resolve(inputs(:, j)'));
            vehicles(j).update(output', euler);
        end
        
        collisions = collisions + collisionCheck(obstacles, vehicles);

        %----------------------------------------------%

    end
    collisions(collisions ~= 0) = 1;
    collisions = sum(collisions, 1);
    ranking = fitness(vehicles, destination, collisions)
    topSelection = ranking(1:breedingSize, 3);
    parents = NeuralNets(topSelection);
    NeuralNets = breed(parents, populationSize, layerArray, fun2);
    
    figure(g);
    hold on; grid on; axis([-5,5,-5,5]); 
    g
    
    for k = 1:length(vehicles)
         plot(vehicles(k).x_matrix(20, :),vehicles(k).x_matrix(19, :)); xlabel('y, m'); ylabel('x, m');
    end
    for m = 1:length(obstacles)
        obstacles(m).inversePlot();
    end
    plot(destination(2), destination(1), '*')


end


fprintf("Simulation Finished\n")

function sorted =  fitness(vehicles, point, collisions)
    
    sorted = zeros(length(vehicles), 3);
    x = [vehicles.xx] - point(1);
    y = [vehicles.y] - point(2);
    distances = sqrt(x.^2 + y.^2);
    [sortedDistances, Id] = sort(distances);
    collisions = collisions(Id);
    [sortedCollisions, Ic] = sort(collisions);
    sorted(:, 1) = distances(Id(Ic));
    sorted(:, 2) = sortedCollisions;
    sorted(:, 3) = Id(Ic);
    Id(Ic);
%     for i = 1:length(a)
% 
%         if i == 1
%             range = 1:sum(a(1:i))
%         else
%             range = sum(a(1:i-1))+1:sum(a(1:i))
%         end
%         [sorted(range, 1), Id] = sort(distances(range));
%         Id
%         sorted(range, 2) = sortedCollisions(range(Id));
%         sorted(range, 3) = Ic(Id)
%     end
%         [~,idx] = sort(sorted(:,2)); % sort just the first column
%         sorted = sorted(idx,:); 
        
        
end

function collisions = collisionCheck(obstacles, vehicles)
    
    a = -([obstacles.starting_y] - [obstacles.end_y])';
    b = ([obstacles.starting_x] - [obstacles.end_x])';
    c =  -(b'.*[obstacles.starting_y] + a'.*[obstacles.starting_x])';
    
    d = abs(a*[vehicles.xx] + b*[vehicles.y] + c)./sqrt(a.^2 + b.^2);
    % d_1 = ([obstacles.starting_y] - [obstacles.end_y])'*[vehicles.xx] - ([obstacles.starting_x] - [obstacles.end_x])'*[vehicles.y ] + ([obstacles.starting_x].*[obstacles.end_y])'- ([obstacles.starting_y].*[obstacles.end_x])';
    % d_2 = abs(d_1)./sqrt(([obstacles.starting_y] - [obstacles.end_y]).^2 + ([obstacles.starting_x] - [obstacles.end_x]).^2)';
    lineCollisions = (d < 0.02);
    if any([vehicles.y] > -3.2) && any([vehicles.y] < -2.9)
        
    end
    cx = -(b.^2./(a.^2 - b.^2))*[vehicles.xx] - (a.*b./(a.^2 - b.^2))*[vehicles.y] - ( a.*c./(a.^2 - b.^2));
    cy = (-a./b).*cx - c./b;
    x = ~isfinite(cy);
    cy(x) = 0;
    cy = cy + x.*[vehicles.y];
    withinRangex = sign([obstacles.starting_x]' - cx) ~= sign([obstacles.end_x]' - cx) + ([obstacles.starting_x]' == [obstacles.end_x]');
    withinRangey = sign([obstacles.starting_y]' - cy) ~= sign([obstacles.end_y]' - cy) + ([obstacles.starting_y]' == [obstacles.end_y]');
    
    withinRange = withinRangex & withinRangey;
    collisions = lineCollisions.*withinRange;
    
end

function NeuralChildren = breed(NeuralParents, childrenNo, layerArray, fun)
    for i = 1:childrenNo
        NeuralChildren(i) = NeuralNet(layerArray, @perceptron, fun, NeuralParents);
    end
end

function alpha = vectorAngle(v1, v2)
   v = v1.*v2;
   dots = v(:,1) + v(:, 2);
   
   norm = sqrt((v1(:, 1).^2 + v1(:, 2).^2).*(v2(:, 1).^2 + v2(:, 2).^2));
   alpha = acos(dots./norm);
end

function dir = curl2D(v1, v2)
    
    v1(:, 1) = -v1(:, 1);
    dir = v1.*flip(v2, 2);
    dir  = sign(dir(:, 1) + dir(:, 2));
end



