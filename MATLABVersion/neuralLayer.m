classdef neuralLayer < handle
    properties
        neurons
        neuronNo 
    end
    methods
        
        function obj = neuralLayer(neurons)
            obj.neurons = neurons;
            obj.neuronNo = length(neurons);
        end
        
        % Reference to drawing
        
        function outputArray = resolve(obj, inputArray)
            outputArray = zeros(1,obj.neuronNo);
            for i = 1:obj.neuronNo
                
                outputArray(i) = obj.neurons(i).input(inputArray);
            end
        end
        
    end
end
