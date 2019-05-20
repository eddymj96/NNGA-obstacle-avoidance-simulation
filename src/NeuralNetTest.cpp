#include <iostream>
#include "NeuralNet.h"
#include "Perceptron.h"
#include "MatrixMultiplication.h"
#include <cmath>

int main() 
{
    //------------ Generate desired neuron and its behaviour-----------------

    // Choosing a Perceptron,  must define its activation function

    auto act_func = [](std::vector<float> weights, std::vector<float> inputs)
    {
        return tanh(linear_algebra::element_mult(weights, inputs));
    };

    // Create model Perceptron with blueprint constructor

    Perceptron perceptron(act_func)


    // ------------ Generate Neural Net with random weightings-----------------

    // Create layer formation
    /* 
        
        IL   HL   OL    
        
            o
            |
            o     o
        o    |     |
        | -> o ->  o
        o    |     |
            o     o
            |
            o

    */

    std::vector<int> layer_formation = {2, 5, 3}; 

    NeuralNet NN(layer_formation, perceptron);

    // ----------------- Test that it provides an output -----------------

    std::vector<float> input;
    input = {0.5, 0.8};

    std::cout << "\n NN output : ";
   
    for(int i=0; i < layer_formation.back(); i++)
        std::cout << output[i] << ' ';

}
