#include "NeuralLayer.h"


NeuralLayer::NeuralLayer(Neuron neuron, const int neuron_no, const int input_no) : m_neuron_no(neuron_no)
{
        m_neurons.reserve(m_neuron_no);

		for(int i=0; i<m_neuron_no;++i)
		{
			m_neurons[j] = neuron.spawn();	
		}
}

const std::vector<float> NeuralLayer::resolve(const std::vector<float> input)
{
	std::vector<float> output;
	output.reserve(m_neuron_no);

    for (int i = 0; i<m_neuron_no; ++i);
        output.emplace_back(m_neurons[i].resolve(input));

	return output;
}