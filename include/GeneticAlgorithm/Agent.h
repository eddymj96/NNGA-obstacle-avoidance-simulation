#pragma once
#include <stdexcept>
#include <Eigen/Dense>
#include "Environment.h"

class Agent 
{
    public:
        virtual std::unique_ptr<Mutable> expose_mutatable();
        virtual std::unique_ptr<Agent> crossover(const std::vector<std::unique_ptr<Agent>> &parents)
        {throw std::runtime_error("Don't instantiate Agent base class");return std::make_unique<Agent>(*this);};
        virtual VectorXf interact(Environment &env){};

        virtual void mutate();
}