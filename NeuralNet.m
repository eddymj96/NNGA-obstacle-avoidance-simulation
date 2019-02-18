classdef NeuralNet
    properties
        layers
        inputs
        outputs
    end
    
    methods
        function obj = NeuralNet(layerArray, neuronType, toleranceFunction)
        for i = 2:length(layerArray)

            for j = 1:layerArray(i)
                    neurons(j) = neuronType(layerArray(i-1), toleranceFunction);
            end

            layers(i-1) = neuralLayer(neurons);
            clear neurons;
            
        end
        
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
