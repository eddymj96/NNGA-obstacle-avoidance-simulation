#include "NeuralNet.h"

NeuralNet::NeuralNet(const std::vector<int> layer_formation, Neuron &master_neuron) : m_layer_formation(layer_formation)
{	
	m_layers.reserve(layer_formation.size() - 1);

	for(int i=1;i<layer_formation.size();++i)
	{
		m_layers[i] = NeuralLayer(master_neuron, layer_formation[i], layer_formation[i-1]);
	}
}

NeuralNet::NeuralNet(const std::vector<int> layer_formation, const std::vector<NeuralNet> &parents)
{
	//TODO
}

const std::vector<float> NeuralNet::resolve(std::vector<float> input)
{

	for(int i=0;i<m_layers.size();++i)
	{
		input = m_layers[i].resolve(input);
	}

	return input;
}

