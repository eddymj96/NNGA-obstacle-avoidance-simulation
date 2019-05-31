#include "NeuralLayer.h"

NeuralLayer::NeuralLayer(std::unique_ptr<Neuron> const &neuron, const int neuron_no, const int input_no) : m_neuron_no(neuron_no)
{
    m_neurons.reserve(m_neuron_no);
	for(int i=0; i<m_neuron_no;++i)
	{
		m_neurons.emplace_back(std::move(neuron->spawn(input_no)));
	}
}

NeuralLayer::NeuralLayer(std::vector<NeuralLayer> parent_layers, const int neuron_no) : m_neuron_no(neuron_no)
{
	// Might consider defining random device and mt as static member, initialised at start of simulation
	// avoid recreating everytime new layer is made
	std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_real_distribution<int> parent_index(0, parent_layers.size()-1);

    m_neurons.reserve(m_neuron_no);
	for(int i=0; i<m_neuron_no;++i)
	{
		m_neurons.emplace_back(std::move(parent_layers[parent_index(mt)]->get_neuron(i)));
	}
}

const std::vector<float> NeuralLayer::resolve(const std::vector<float> input)
{
	std::vector<float> output;
	output.reserve(m_neuron_no);

    for (int i = 0; i<m_neuron_no; ++i)
        output.emplace_back(m_neurons[i]->resolve(input));
		
	return output;
}

std::unique_ptr<Neuron> NeuralLayer::get_neuron(const int &index)
{
	return m_neurons[index];
}