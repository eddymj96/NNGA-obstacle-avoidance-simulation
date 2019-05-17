#pragma once 
#include <vector>
#include "NeuralLayer.h"

template<typename NeuronType>
class NeuralNet
{
    private:
        std::vector<NeuralLayer> layers;
        const vector<int> m_layer_formation;

    public:

        NeuralNet(const std::vector<float> layer_formation, );
        NeuralNet(const layers, const parents);

        const std::vector<float> resolve(const std::vector<float> input);
}