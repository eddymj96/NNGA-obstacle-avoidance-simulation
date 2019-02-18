% NeuralNet Test environment
clc;
clear all;
close all;

% ---------Constructing the Neural Net----------
%-----------------------------------------------

% Define the activation function in terms of two inputs 
% An array of inputs to the neuron and their corresponding weights
% So it would look like output = fun(inputs, weights)

fun = @(inputs, weights)sigmf(sum(inputs.*weights), [1,1]);

layerArray = [2, 2, 3, 2]; % Specify Number of layers and number neurons, first term is the input number

myNet = NeuralNet(layerArray, @perceptron, fun);



    
function output = toleranceFunction(inputs, weights)
    if sum(inputs.*weights) < 0.5
        output = 0;
    elseif sum(inputs.*weights) < 1
        output = 0.5;
    else 
        output = 1;
    end
end

