#include "NeuralNet.h"
#include "NeuralLayer.h"
#include "Neuron.h"

NeuralNet::NeuralNet(const std::vector<float> layer_formation) : m_layer_formation(layer_formation)
{
    std::vector<Neuron> neurons;
	neurons.reserve(neuron_no);

	for(int i = 0; i<neuron_no;++i)
		std::vector<Neuron> neurons[i] = NeuronType();	
}
}

