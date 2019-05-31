#pragma once 
#include "Neuron.h"
#include <vector>

class NeuralLayer 
{
    public:
        std::vector<std::unique_ptr<Neuron>> m_neurons;
        int m_neuron_no; 
    
        NeuralLayer(std::unique_ptr<Neuron> const &neuron, const int neuron_no, const int input_no);
        const std::vector<float> resolve(const std::vector<float> input);
        
};