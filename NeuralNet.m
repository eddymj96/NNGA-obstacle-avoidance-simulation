classdef NeuralNet
    properties
        layers
        layerArray
        inputs
        outputs
    end
    
    methods
        function obj = NeuralNet(layerArray, neuronType, toleranceFunction, parents)
            
            obj.layerArray = layerArray;
      
            for i = 2:length(layerArray)

                for j = 1:layerArray(i)
                    if isempty(parents)
                        neurons(j) = neuronType(layerArray(i-1), toleranceFunction, []);
                    else
                        weights = zeros(1, layerArray(i-1));
                        for k = 1:layerArray(i-1)
                            weights(k) = parents(randi([1, length(parents)], 1)).layers(i-1).neurons(j).weights(k);
                        end
                        weights = weights + rand(1, layerArray(i-1))/5;
                        neurons(j) = neuronType(layerArray(i-1), toleranceFunction, weights);
                    end
                        
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
