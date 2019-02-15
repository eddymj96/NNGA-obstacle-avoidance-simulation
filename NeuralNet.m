classdef NeuralNet
    properties
        layers
        inputs
        outputs
    end
    
    methods
        function obj = NeuralNet(layers)
            obj.layers = layers;
        end
        
        function outputs = resolve(obj, inputs)
            for i = 1:length(obj.layers)
                inputs = obj.layers(i).resolve(inputs);
            end
            outputs = inputs;
        end
    end
end
