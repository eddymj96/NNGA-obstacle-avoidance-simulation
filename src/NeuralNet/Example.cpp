#include <iostream>
#include <cmath>
#include "NeuralNet.h"
#include "Perceptron.h"
#include "MatrixMultiplication.h"


//#include <cmath>

int main() 
{
    //------------ Generate desired neuron and its behaviour-----------------

    // Choosing a Perceptron, must define its activation function

    const ACT_FUNC act_func = [](std::vector<float> weights, std::vector<float> inputs)
    {
        return std::tanh(linear_algebra::element_mult_sum(weights, inputs));
    };

    // Create model Perceptron with blueprint constructor

    std::unique_ptr<Neuron> neuron = std::make_unique<Perceptron>(Perceptron(act_func));

    // ------------ Generate Neural Net with random weightings-----------------

    // Create layer formation
    /* 
        
        IL   HL   OL    
        
             o
             |
             o    o
        o    |    |
        | -> o -> o
        o    |    |
             o    o
             |
             o

    
    */

    std::vector<int> layer_formation = {3, 5, 8, 4}; 

    NeuralNet NN(layer_formation, neuron);


    // ----------------- Test that it provides an output -----------------

    std::vector<float> input, output;
    input = {0.5, 0.8, 0.4};
    output = NN.resolve(input);

    std::cout << "NN output : ";
   
    for(int i=0; i < output.size(); i++)
        std::cout << output[i] << ' ';

    std::cout << std::endl;
    
};
