#include "NeuralNet.h"

NeuralNet::NeuralNet(const std::vector<int> layer_formation, std::unique_ptr<Neuron> &master_neuron) : m_layer_formation(layer_formation)
{	
	m_layers.reserve(layer_formation.size() - 1);
	
	for(int i=0;i<layer_formation.size()-1;++i) // for no. of layers (apart from input layer so -1)
	{
		m_layers.emplace_back(NeuralLayer(master_neuron, layer_formation[i+1], layer_formation[i]));
		
	}
}

NeuralNet::NeuralNet(const std::vector<int> layer_formation, const std::vector<std::unique_ptr<NeuralNet>> &parents) : m_layer_formation(layer_formation)
{
	// TODO fix innefficient implementation
	// TODO implement mutation and add mutation factor as an argument
	// TODO change vector arrays to eigen and subsequent Perceptron and Neural Layer classes

	

	m_layers.reserve(layer_formation.size() - 1);

	std::vector<NeuralLayer> layer_array;

	for(int i=0;i<layer_formation.size()-1;++i)
	{
		for(int j=0;j<parents.size();++j)
		{
			layer_array.emplace(parents->get_layer(i));
		}

		m_layers.emplace_back(NeuralLayer(layer_array, layer_formation[i+1]));

		layer_array.clear();
		
	}

	

	
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

std::vector<int> get_layer_formation()
{
	return m_layer_formation;
}

std::vector<NeuralLayer> get_layer(const int &index)
{
	return m_layers[index];
}