#include "Perceptron.h"
#include <random>
#include <stdexcept>

Perceptron::Perceptron(const std::vector<float> weights) : m_weights(weights), m_input_no(weights.size()), m_act_func(act_func)
{ 

}

Perceptron::Perceptron(const int input_no, const auto act_func) : m_input_no(input_no), m_act_func(act_func)
{
    m_weights.reserve(m_input_no)

    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_real_distribution<double> weights(-1.0, 1.0);
    for (int i=0; i<m_input_no; ++i)
        m_weights.emplace_back(weights(mt));

}

const float Perceptron::resolve(const std::vector<float> input)
{
    if(input.size() != m_weights.size())
    {
        throw std::runtime_error("\n Input and weight vector are not the same size");
    }

    std::vector<float> output = m_act_func(m_weights, input);
    return output;
}

Perceptron Perceptron::spawn()
{
    Perceptron output(m_input_no, m_act_func);

    return output;
}
