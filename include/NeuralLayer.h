#pragma once 
#include <vector>

class NeuralLayer 
{
    private:
        std::vector<Neuron> m_neurons;
        const int m_neuron_no; 
    public:
        NeuralLayer(const std::vector<Neuron> neurons);
        const std::vector<float> resolve(const std::vector<float> input);
        
}