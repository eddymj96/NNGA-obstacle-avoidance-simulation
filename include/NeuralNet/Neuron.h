#pragma once
#include <vector>
#include <memory>
#include <iostream>
/* Neuron Base class; right now only works for basic weight based neuron cells 
should be expanded to involve more complex neuron types like LSTM cells etc
*/

class Neuron
{
    public:
        virtual const float resolve(const std::vector<float> input) {return -1;}; 
        virtual std::unique_ptr<Neuron> spawn(const int input_no) {return std::make_unique<Neuron>(*this);};
        virtual const int get_info() {std::cout << "Neuron" << std::endl; return 0;};
};