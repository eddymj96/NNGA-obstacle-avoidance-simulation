#include "NeuralNet.h"

NeuralNet::NeuralNet(const std::vector<int> layer_formation, std::unique_ptr<Neuron> &master_neuron) : m_layer_formation(layer_formation)
{	
	m_layers.reserve(layer_formation.size() - 1);
	
	for(int i=0;i<layer_formation.size()-1;++i)
	{
		m_layers.emplace_back(NeuralLayer(master_neuron, layer_formation[i+1], layer_formation[i]));
		
	}
}

NeuralNet::NeuralNet(const std::vector<int> layer_formation, const std::vector<NeuralNet> &parents)
{
	//TODO
}

const std::vector<float> NeuralNet::resolve(std::vector<float> &input)
{
	std::vector<float> output = input;
	for(int i=0;i<m_layers.size();++i)
	{
		output = m_layers[i].resolve(output);
	}

	return output;
}