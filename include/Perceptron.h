#include "Neuron.h"
#include "ActivationFunction.h"

class Perceptron : public Neuron 
{
    private: 
        std::vector<float> m_weights;
        const int m_input_no;
        const auto m_act_func;
    public:
        Perceptron(const std::vector<float> weights, const shared_ptr<ActivationFunction> act_func);
        Perceptron(const int input_no, const shared_ptr<ActivationFunction> act_func);
        const float resolve(const std::vector<float> input);
}