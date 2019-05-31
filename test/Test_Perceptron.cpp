#include "gtest/gtest.h"
#include "Perceptron.h"
#include "NeuralNet.h"
#include "MatrixMultiplication.h"
#include <cmath>

TEST(PerceptronTest, DefaultConstruction)
{
	//create activation function
	const ACT_FUNC act_func = [](std::vector<float> weights, std::vector<float> inputs)
	{
		return std::tanh(linear_algebra::element_mult_sum(weights, inputs));
	};

	std::vector<float> test_weights = {0.1, 0.2, 0.3};
	std::vector<float> test_inputs = {1, 2, 3};
	const float manual_calculation = 1.4;
	const float manual_tanh_calculation = 0.88535166;

	//test element multiplication
	EXPECT_FLOAT_EQ(linear_algebra::element_mult_sum(test_weights, test_inputs),  manual_calculation);
	//test commutative property
	EXPECT_FLOAT_EQ(linear_algebra::element_mult_sum(test_inputs, test_weights),  manual_calculation);
	//test activation function
	EXPECT_FLOAT_EQ(act_func(test_weights, test_inputs), manual_tanh_calculation);

    
    const std::vector<float> p_in = {2, 4}; 
	Perceptron test_perceptron(p_in.size(), act_func);
	const float ouput_upper_bound = 1;
	const float ouput_lower_bound = -1;

	//test output bounds
	const float bound_output_test = test_perceptron.resolve(p_in);
	EXPECT_LT(bound_output_test, ouput_upper_bound);

	EXPECT_GT(bound_output_test, ouput_lower_bound);

	//test weight bounds
    const std::vector<float> bound_weights_test = test_perceptron.get_weights();

	EXPECT_LT(bound_weights_test[0], ouput_upper_bound);
	EXPECT_LT(bound_weights_test[1], ouput_upper_bound);

	EXPECT_GT(bound_weights_test[0], ouput_lower_bound);
	EXPECT_GT(bound_weights_test[1], ouput_lower_bound);


    //Polymorphism tests

    std::unique_ptr<Perceptron> per_ptr = std::make_unique<Perceptron>(Perceptron(act_func));

    std::unique_ptr<Neuron> neuron1;
    neuron1 = std::move(per_ptr);

	const int neuron_instance = 0;
	const int perceptron_instance = 1;

	//test that Neuron type smrt_ptr can be assigned to perceptron smrt_ptr
	ASSERT_EQ(neuron1->get_info(), perceptron_instance);

    std::unique_ptr<Neuron> neuron2;
    neuron2 = std::move(neuron1->spawn(3));

	//test that clone function returns perceptron type 
	ASSERT_EQ(neuron2->get_info(), perceptron_instance);

	//Layer test

	std::unique_ptr<Neuron> test_neuron = std::make_unique<Perceptron>(Perceptron(act_func));

	const int neuron_no = 10;
	const int input_no = 3;

	NeuralLayer layer_test(test_neuron, neuron_no , input_no);

	std::vector<float> layer_output;
	layer_output = layer_test.resolve(test_inputs);

	//ensure output size is as large as no of neurons
	ASSERT_EQ(layer_output.size(), neuron_no);

	//Neural net test
	std::vector<int> test_layer_formation = {3, 5, 8, 4}; 

    NeuralNet test_NN(test_layer_formation, test_neuron);

	std::vector<float> NN_output;

	NN_output = test_NN.resolve(test_inputs);

	//test that output is same size as neuron no in final layer
	ASSERT_EQ(NN_output.size(), test_layer_formation.back());

	//test output bounds
	EXPECT_LT(NN_output[0], ouput_upper_bound);
	EXPECT_LT(NN_output[1], ouput_upper_bound);
	EXPECT_LT(NN_output[2], ouput_upper_bound);
	EXPECT_LT(NN_output[3], ouput_upper_bound);

	EXPECT_GT(NN_output[0], ouput_lower_bound);
	EXPECT_GT(NN_output[2], ouput_lower_bound);
	EXPECT_GT(NN_output[3], ouput_lower_bound);
	EXPECT_GT(NN_output[4], ouput_lower_bound);

}

class Test_Perceptron : public ::testing::Test {
protected:
  Test_Perceptron() {}

  virtual void SetUp() {}

  virtual void TearDown() {}
};

