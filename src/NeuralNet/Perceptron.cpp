#include "Perceptron.h"
#include <random>
#include <stdexcept>        

    
    
Perceptron::Perceptron(const std::vector<float> weights, const ACT_FUNC act_func): m_weights(weights), m_input_no(weights.size()), m_act_func(act_func)
{ 
    
}

Perceptron::Perceptron(const int input_no, const ACT_FUNC act_func) : m_input_no(input_no), m_act_func(act_func)
{
    m_weights.reserve(m_input_no);

    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_real_distribution<float> weights(-1.0, 1.0);
    for (int i=0; i<m_input_no; ++i)
        m_weights.emplace_back(weights(mt));

}

Perceptron::Perceptron(const ACT_FUNC act_func): m_act_func(act_func)
{ 
    // Blueprint Constructor
}
        
const float Perceptron::resolve(const std::vector<float> input)
{
    
    if(input.size() != m_weights.size())
    {
        throw std::runtime_error("\n Input and weight vector are not the same size");
    }

        float output = m_act_func(m_weights, input);
        return output;
}

const std::vector<float> Perceptron::get_weights()
{
    return m_weights;
}


std::unique_ptr<Neuron> Perceptron::spawn(const int input_no)
{
    //Perceptron perceptron(input_no, m_act_func);
    //TODO possibly fix this 
    //Perceptron *temp;
    //temp = &perceptron;
    //std::unique_ptr<Neuron> output;
    //output = std::make_unique<Perceptron>(*temp);

    return std::make_unique<Perceptron>(input_no, m_act_func);
}   

const int Perceptron::get_info()
{
    std::cout << "Perceptron" << std::endl;
    return 1;
}