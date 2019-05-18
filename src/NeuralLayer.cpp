#include "NeuralLayer.h"


NeuralLayer::NeuralLayer(Neuron neuron, const neuron_no) : m_neuron_no(neuron_no)
{
        m_neurons.reserve(m_neuron_no);

		for(int i=0; i<m_neuron_no;++i)
		{
			m_neurons[j] = neuron.spawn();	
		}
}

NeuralLayer::resolve(const std::vector<float> input)
{
    for (int i = 0; i<m_neuron_no; ++i);
        std::vector<float> output[i] = m_neurons[i].resolve(input);
}