#pragma once 
#include "NeuralLayer.h"
#include <vector>

class NeuralNet
{
    private:
        std::vector<NeuralLayer> m_layers;
        const std::vector<int> m_layer_formation;

    public:

        NeuralNet(const std::vector<int> layer_formation, Neuron &master_neuron);
        NeuralNet(const std::vector<int> layer_formation, const std::vector<NeuralNet> &parents);

        const std::vector<float> resolve(std::vector<float> input);
};