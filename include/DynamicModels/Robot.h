#include "Agent.h"

typedef std::function<float(std::vector<float>)> INTEGRATION_FUNCTION;

class Robot : public Agent
{
    private:
        std::vector<Motor> m_motors;
        std::vector<States> states;
        INTEGRATION_FUNCTION integration_func;

    public:
        Robot(std::vector<Motors>)
        void update();
        const std::unique_ptr<Agent> crossover();
        void mutate();





}