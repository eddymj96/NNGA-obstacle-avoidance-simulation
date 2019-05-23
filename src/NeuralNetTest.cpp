#include <iostream>
#include <cmath>
#include "NeuralNet.h"
#include "Perceptron.h"
#include "MatrixMultiplication.h"


//#include <cmath>

int main() 
{
    //------------ Generate desired neuron and its behaviour-----------------

    // Choosing a Perceptron,  must define its activation function

    const ACT_FUNC act_func = [](std::vector<float> weights, std::vector<float> inputs)
    {
        return std::tanh(linear_algebra::element_mult_sum(weights, inputs));
    };

    // Create model Perceptron with blueprint constructor

    Perceptron perceptron1(2, act_func);

    const std::vector<float> p_in = {2, 4}; 
    const float p_out = perceptron1.resolve(p_in);
    const std::vector<float> weights = perceptron1.get_weights();

    for (float weight : weights) 
        std::cout << weight << std::endl; 
    std::cout << "\n linear_algebra result : " << act_func(weights, p_in) << std::endl;
    std::cout << "\n linear_algebra commutative test : " << act_func(p_in, weights) << std::endl;
    std::cout << "\n Perceptron1 output : " << p_out << std::endl;

    Perceptron perceptron2(act_func);

    //Polymorphism tests

    std::unique_ptr<Perceptron> p3_ptr = std::make_unique<Perceptron>(Perceptron(act_func));

    std::unique_ptr<Neuron> neuron1;
    neuron1 = std::move(p3_ptr);
    neuron1->get_info();

    std::unique_ptr<Neuron> neuron2;
    neuron2 = std::move(neuron1->spawn(3));
    neuron2->get_info();

    const std::vector<float> spawn_in = {2, 4, 5}; 
    const float spawn_out = neuron2->resolve(spawn_in);
    std::cout << "Spawn output: " << spawn_out << std::endl; 

    std::unique_ptr<Neuron> neuron_test = std::make_unique<Perceptron>(Perceptron(act_func));

    /*Neuron *neuron1;
    neuron1 = &perceptron1;
    neuron1->get_info();

    Neuron neuron2;
    neuron2 = neuron1->spawn(3);
    neuron2.get_info();

    Neuron *neuron3;
    neuron3 = perceptron1.spawn(3);
    neuron3->get_info();
    */

    
    

    NeuralLayer layer1(neuron_test, 4, 2);
    
    std::cout << layer1.m_neurons.size() << std::endl; 
    std::cout << layer1.m_neuron_no << std::endl; 

    layer1.m_neurons[0]->get_info();

    const std::vector<float> layer_output = layer1.resolve(p_in);
    
    for (float out : layer_output) 
        std::cout << out << std::endl; 

    std::vector<float> layer_input = {2, 2};

    layer_input = layer1.resolve(layer_input);

    for (float inp : layer_input) 
        std::cout << "Layer override: " << inp << std::endl; 

    std::vector<NeuralLayer> layers;
    layers.emplace_back(NeuralLayer(neuron_test, 1, 2));
    std::cout << "layer vector test: " << layers[0].resolve(p_in)[0] << std::endl;



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

    std::vector<int> layer_formation = {3, 5, 8, 2}; 

    NeuralNet NN(layer_formation, neuron_test);

    

    // ----------------- Test that it provides an output -----------------

    std::vector<float> input, output;
    input = {0.5, 0.8, 0.4};
    output = NN.resolve(input);

    std::cout << "NN output : ";
   
    for(int i=0; i < output.size(); i++)
        std::cout << output[i] << ' ';
    
};
