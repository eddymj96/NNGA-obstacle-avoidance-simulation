#pragma once 
#include "Environment.h"
#include <Eigen/Dense>

class Sensor
{
    public:
        virtual Eigen::VectorXf detect(std::vector<float> sensor_states, Environment &env);
}