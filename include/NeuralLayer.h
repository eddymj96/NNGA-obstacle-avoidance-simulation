#pragma once 
#include "Neuron"

class NeuralLayer 
{
    private:
        std::vector<Neuron> m_neurons;
        const int m_neuron_no; 
    public:
        NeuralLayer(Neuron neuron, const int neuron_no, const int input_no);
        const std::vector<float> resolve(const std::vector<float> input);
        
}