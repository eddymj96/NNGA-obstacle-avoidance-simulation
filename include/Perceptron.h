#pragma once
#include "Neuron.h"
#include <vector>

template<typename lambda>
class Perceptron : public Neuron 
{
    private: 
        std::vector<float> m_weights;
        const int m_input_no;
        const lambda m_act_func;
    public:
        Perceptron(const std::vector<float> weights, const lambda act_func);
        Perceptron(const int input_no, const lambda act_func);
        Perceptron(const lambda act_func);
        const float resolve(const std::vector<float> input);
        Neuron spawn(const int input_no);
};