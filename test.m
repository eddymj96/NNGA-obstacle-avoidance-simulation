clear all;
close all;
clc;

sim_time = 60;
dT = 0.05;
Vl = 6;
Vr = 6;
Va = [Vl; Vl; Vr; Vr];

euler = @(x, x_dot, dt)x + (x_dot*dt); % Euler intergration

populationSize = 30;
breedingSize = 3;
generations = 15;
xi = zeros(1,24);
xi(19) = -2;
xi(20) = -1;

fun2 = @(inputs, weights)tanh(sum(inputs.*weights));
layerArray = [3, 4, 2]; 

obstacles = [wallObject(1.2, -1, 1.2, 1), wallObject(4, -3, 4, 1), wallObject(-5, -3, 2, -3), wallObject(-3, 2, 1, 2), ];
obstacles = [wallObject(-5, -3, 2, -3)];

perfectNet = NeuralNet(layerArray, @perceptron, fun2, []);
% perfectNet.layers(1).neurons(1).weights = [1, 0, 0.3 0.2];
% perfectNet.layers(1).neurons(2).weights = [0, 1, 0.3 0.2];
 perfectNet.layers(1).neurons(1).weights = [-1, 0, 0];
 perfectNet.layers(1).neurons(2).weights = [1, 0, 0];
 perfectNet.layers(1).neurons(3).weights = [0, 1, 0];
 perfectNet.layers(1).neurons(4).weights = [0, 0, 1];
 
 perfectNet.layers(2).neurons(1).weights = [1, 0, 0.3 0.1];
 perfectNet.layers(2).neurons(2).weights = [0, 1, 0.3 0.1];

sensor = PerfectObservationSensor(obstacles, 0.1, pi/8, 1);

for i = 1:populationSize
    NeuralNets(i) = NeuralNet(layerArray, @perceptron, fun2, []);
    
    NeuralNets(i).layers(1).neurons(1).weights = [-1, 0, 0];
    NeuralNets(i).layers(1).neurons(2).weights = [1, 0, 0];
    NeuralNets(i).layers(1).neurons(3).weights = [0, 1, 0];
    NeuralNets(i).layers(1).neurons(4).weights = [0, 0, 1];

    NeuralNets(i).layers(2).neurons(1).weights = [1, 0, 0.3 0.1];
    NeuralNets(i).layers(2).neurons(2).weights = [0, 1, 0.3 0.1];
    
end

destinations = [0, 3; 1, 2;-1,  4; -1, -2; -0.2, 2];
% destinations = [2.5, 3.5];
%destinations = [0, 3];


inputs = zeros(layerArray(1), populationSize);

%myNet = NeuralNet(layerArray, @perceptron, fun2, []);
%myNet
distance = zeros(1, populationSize);
pathIntegration  = zeros(1, populationSize);
straightness = zeros(1, populationSize)';


for g = 1:generations 
    d = ones(1 , populationSize);
    for i = 1:populationSize
    
        vehicles(i) = robot(xi, Va, 0, 0, 0, 0, dT, sim_time);
    end
    
    collisions = zeros(1, populationSize);

    for outer_loop = 1:(sim_time/dT)

        %----------------------------------------------%
        % Run Model
        %headingError = cell2mat({vehicles.psi}) - atan((cell2mat({vehicles.y}) - destinations(d, 2)')./ (cell2mat({vehicles.xx}) - destinations(d, 1)'));
        v1 = [cos([vehicles.psi])', sin([vehicles.psi])'];
        v2 = [(destinations(d, 1)' - [vehicles.xx])', (destinations(d, 2)' - [vehicles.y])'];
        error2 = vectorAngle(v1, v2).*curl2D(v1, v2);
        headingError = error2;
        %inputs(1, :) = 3*error2;
        %inputs(2, :) = sqrt((cell2mat({vehicles.y}) - 2.5).^2 + (cell2mat({vehicles.xx}) - 3.5).^2);
        distanceError = sqrt((cell2mat({vehicles.y}) - destinations(d, 2)').^2 + (cell2mat({vehicles.xx}) - destinations(d, 1)').^2)';

        v = v2.^2;
        error3 = sqrt(v(:, 1) + v(:, 2));
        %velocity =  sqrt([vehicles.xdot(13)].^2 + [vehicles.xdot(14)].^2);
        
        %inputs(1, :) = -error2.*distanceError;
        inputs(1, :) = error2.*distanceError;
        inputs(2, :) = distanceError;
        %inputs(4, :) = (1./velocity)';
        
        if any(distanceError < 0.1)
            ind = find(distanceError < 0.1);
            d(ind) = d(ind) + 1;
            pointsHit = d;
            if any(d(ind) > length(destinations))
                ind2 = find(d > length(destinations));
                d(ind2) = d(ind2)-1;
            end
        end
        
        %linePoints = [[-2, -1], destinations(d, 1:2)];
        %points = [[vehicles.xx]',[vehicles.y]'];
        %dApart = distanceApart(linePoints, points);
        straightness = straightness + abs(error2);
        
        
        
        for j = 1:length(vehicles)
            
            

            
            inputs(3, j) =   1/max(sqrt(vehicles(j).xdot(13)^2 + vehicles(j).xdot(14)^2), 0.001);
            %inputs(3, j) = vehicles(j).xdot(14);
           
% 
            w1 = 7;
            w2 = 2;
            w3 = 0.3;
%             [cos(headingError), sin(headingError)];
            velocity =  sqrt(vehicles(j).xdot(13)^2 + vehicles(j).xdot(14)^2);
            
            %output = min(max(w1*[-headingError(j)*distanceError(j), headingError(j)*distanceError(j)] + w2*distanceError(j) + w3/velocity, -7.5), 7.5)
            output = min(max(15*(NeuralNets(j).resolve(inputs(:, j)')), -7.5), 7.5);
            %output = min(max(15*(perfectNet.resolve(inputs(:, j)')), -7.5), 7.5)
            
            vehicles(j).update(output', euler);
        end
        
        collisions = collisions + collisionCheck(obstacles, vehicles);
        %----------------------------------------------%

    end
    
    %traveledDistance =
    
    collisions(collisions ~= 0) = 1;
    collisions = sum(collisions, 1);
    ranking = fitness2(vehicles, pointsHit)
    topSelection = ranking(1:breedingSize, end);
    parents = NeuralNets(topSelection);
    NeuralNets = breed(parents, populationSize, layerArray, fun2);
    g
    
    figure(g);
    hold on; grid on; axis([-5,5,-5,5]); 

    for k = 1:length(vehicles)
         vehicles(k).trimPath();
         plot(vehicles(k).x_matrix(20, :),vehicles(k).x_matrix(19, :)); xlabel('y, m'); ylabel('x, m');
    end
    
%     for m = 1:length(obstacles)
%         obstacles(m).inversePlot();
%     end

    plot(destinations(:, 2), destinations(:, 1), '*')


end
figure(g + 1);
hold on;grid on; axis([-5,5,-5,5]); 
plot(vehicles(topSelection(1)).x_matrix(20, :),vehicles(topSelection(1)).x_matrix(19, :)); xlabel('y, m'); ylabel('x, m');
% for m = 1:length(obstacles)
%         obstacles(m).inversePlot();
% end
plot(destinations(:, 2), destinations(:, 1), '*')

function sorted =  fitness(vehicles, point, collisions, straightness)
    
    sorted = zeros(length(vehicles), 6);
    x = [vehicles.xx] - point(1);
    y = [vehicles.y] - point(2);
    distances = sqrt(x.^2 + y.^2);
    
    distanceTravelled = [vehicles.distanceTravelled];
    
    w1 = 1; % distance error weighting 1 1.3
    w2 = 0.2; % distance travelled weighting 0.2 0.1
    w3 = 0; %0.002;
    hyperParam = w1*distances + w2*distanceTravelled + w3*straightness';
    [sortedParam, Id] = sort(hyperParam);
    collisions = collisions(Id);
    [sortedCollisions, Ic] = sort(collisions);
    sorted(:, 1) = hyperParam(Id(Ic));
    sorted(:, 2) = w1*distances(Id(Ic));
    sorted(:, 3) = w2*distanceTravelled(Id(Ic));
    sorted(:, 4) = w3*straightness(Id(Ic));
    sorted(:, 5) = sortedCollisions;
    sorted(:, 6) = Id(Ic);
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

function sorted =  fitness2(vehicles, points)
    
    sorted = zeros(length(vehicles), 3);
    
    distanceTravelled = [vehicles.distanceTravelled];
    
    hyperParam = distanceTravelled;
    [sortedParam, Id] = sort(hyperParam);
    points = points(Id);
    [sortedPoints, Ic] = sort(points, 'descend');
    sorted(:, 1) = hyperParam(Id(Ic));
    sorted(:, 2) = sortedPoints;
    sorted(:, 3) = Id(Ic);
    Id(Ic);
       
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

function d = distanceApart(linePoints, points)
    a = -(linePoints(3) - linePoints(4));
    b = (linePoints(1)- linePoints(2));
    c =  -(b*linePoints(3) + a*linePoints(1));
    
    d = abs(a*points(:, 1) + b*points(:, 2) + c)/sqrt(a^2 + b^2);
    
end
