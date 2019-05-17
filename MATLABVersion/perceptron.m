classdef perceptron < handle
    properties
        inputs
        output
        tolerenceFunction 
        weights
    end
    
    methods
        
        function obj = perceptron(inputNo, tolerenceFunction, weights)
            
            obj.tolerenceFunction = tolerenceFunction;
            
            if isempty(weights)
                obj.weights = 1 - 2*rand(1, inputNo);
            else
                obj.weights = weights;
            end
                
        end
        
        function output = input(obj, inputs)
            obj.inputs = inputs;
            
            output = obj.tolerenceFunction(inputs, obj.weights);
            obj.output = output;
        end
        
    end
end


