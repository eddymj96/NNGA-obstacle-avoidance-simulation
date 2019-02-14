classdef perceptron < handle
    properties
        inputs
        output
        tolerenceFunction 
        weights
    end
    
    methods
        function obj = perceptron(inputNo, tolerenceFunction)
            obj.tolerenceFunction = tolerenceFunction;
            obj.weights = rand(1, inputNo);
        end
        
        function output = input(obj, inputs)
            obj.inputs = inputs;
            output = obj.tolerenceFunction(inputs.*obj.weights);
        end
        
    end
end


