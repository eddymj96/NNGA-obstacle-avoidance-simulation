#include <stdexcept>

class Agent 
{
    public:
        virtual std::unique_ptr<Agent> crossover(const std::vector<std::unique_ptr<Agent>> &parents)
        {throw std::runtime_error("Don't instantiate Agent base class");return std::make_unique<Agent>(*this);};

        virtual void mutate();
}