#pragma once
#include "Neuron.h"

class Perceptron : public Neuron 
{
    private: 
        std::vector<float> m_weights;
        const int m_input_no;
        const auto m_act_func;
    public:
        Perceptron(const std::vector<float> weights, const auto act_func);
        Perceptron(const int input_no, const auto act_func);
        Perceptron(const auto act_func);
        const float resolve(const std::vector<float> input);
        Perceptron spawn(const int input_no);
}