% NeuralNet Test environment
clc;
clear all;
close all;

% ---------Constructing the neural net----------
fun = @toleranceFunction;

% for i = 1:2
%     perceptrons(i) = perceptron(2, fun);
% end
% layer1 = neuralLayer(perceptrons);
% 
% for i = 1:2
%     perceptrons2(i) = perceptron(2, fun);
% end
% layer2 = neuralLayer(perceptrons2);

layerArray = [2, 2, 3, 2]; % Specify Number of layers and number neurons, first term is the input number

myNet = neuralNetCreator(layerArray, @perceptron, fun);


    
function output = toleranceFunction(inputs, weights)
    if sum(inputs.*weights) < 0.5
        output = 0;
    elseif sum(inputs.*weights) < 2
        output = 0.5;
    else 
        output = 3;
    end
end

function net = neuralNetCreator(layerArray, neuronType, toleranceFunction)
    
    for i = 2:length(layerArray)

        for j = 1:layerArray(i)
                neurons(j) = neuronType(layerArray(i-1), toleranceFunction);
        end

        layers(i-1) = neuralLayer(neurons);
        clear neurons;
    end
    
    net = NeuralNet(layers);

end
