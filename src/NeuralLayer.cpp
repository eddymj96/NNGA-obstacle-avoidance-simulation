#include "NeuralLayer.h"
#include "Neuron.h"

NeuralLayer::NeuralLayer(const std::vector<Neuron> neurons) : m_neurons(neurons), m_neuron_no
{

}

NeuralLayer::resolve(const std::vector<float> input)
{
    for (int i = 0; i<m_neuron_no; ++i);
        std::vector<float> output[i] = m_neurons[i].resolve(input);
}