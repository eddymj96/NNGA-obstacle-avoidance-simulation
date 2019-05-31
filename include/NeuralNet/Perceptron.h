#pragma once
#include "Neuron.h"
#include <vector>
#include <functional>

typedef std::function<float(std::vector<float>, std::vector<float>)> ACT_FUNC;

class Perceptron : public Neuron 
{
    private: 
        std::vector<float> m_weights;
        int m_input_no;
        const ACT_FUNC m_act_func;
    public:
        Perceptron(const std::vector<float> weights, const ACT_FUNC act_func);
        Perceptron(const int input_no, const ACT_FUNC act_func);
        Perceptron(const ACT_FUNC act_func);
        const float resolve(const std::vector<float> input);
        const std::vector<float> get_weights();
        std::unique_ptr<Neuron> spawn(const int input_no);
        std::unique_ptr<Neuron> spawn_copy();
        const int get_info();
}; 