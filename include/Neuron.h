#pragma once
#include <vector>

/* Neuron Base class; right now only works for basic weight based neuron cells 
should be expanded to involve more complex neuron types like LSTM cells etc
*/

class Neuron
{
    public:
        virtual const float resolve(const std::vector<float> input); 
        virtual Neuron spawn(const int input_no);
};