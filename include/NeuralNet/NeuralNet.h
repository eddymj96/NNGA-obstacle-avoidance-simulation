#pragma once 
#include "NeuralLayer.h"
#include <vector>

class NeuralNet : public Mutatable
{
    private:
        std::vector<NeuralLayer> m_layers;
        const std::vector<int> m_layer_formation;

    public:

        NeuralNet(const std::vector<int> layer_formation, std::unique_ptr<Neuron>  &master_neuron);
        NeuralNet(const std::vector<int> layer_formation, const std::vector<std::unique_ptr<NeuralNet>> &parents);

        const std::vector<float> resolve(std::vector<float> &input);
        std::vector<int> get_layer_formation();
};