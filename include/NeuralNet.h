#pragma once 
#include "NeuralLayer.h"

class NeuralNet
{
    private:
        std::vector<NeuralLayer> m_layers;
        const vector<int> m_layer_formation;

    public:

        NeuralNet(const std::vector<int> layer_formation, Neuron master_neuron);
        NeuralNet(const std::vector<int> layer_formation, const std::vector<NeuralNet> parents);

        const std::vector<float> resolve(const std::vector<float> input);
}