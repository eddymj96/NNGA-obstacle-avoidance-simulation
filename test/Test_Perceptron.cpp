#include "gtest/gtest.h"
#include "Perceptron.h"
#include "MatrixMultiplication.h"

TEST(PerceptronTest, DefaultConstruction)
{
	auto act_func = [](std::vector<float> weights, std::vector<float> inputs)
	{
		return (linear_algebra::element_mult(weights, inputs));
	};

	Perceptron perceptron<act_func>;
}

class Test_Perceptron : public ::testing::Test {
protected:
  Test_Perceptron() {}

  virtual void SetUp() {}

  virtual void TearDown() {}
};

