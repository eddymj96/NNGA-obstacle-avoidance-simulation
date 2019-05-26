#include "Agent.h"
#include "Environment.h"


typedef std::function<float(std::vector<float>)> FITNESS_FUNCTION;

class GeneticAlgorithm
{
    private:
        std::vector<Agent> m_agents;
        Environment m_environment;
        FITNESS_FUNCTION m_fitness_func;
        int m_generations;
        int m_population_size;
        int m_breeding_size;
    
    public:
        GeneticAlgorithm(Agent &master_agent, Environment &env, FITNESS_FUNCTION fitness_func, const int generations const int population_size, const int breeding_size, const int) :
        m_environment(env), m_fitness_func(fitness_func), m_generations(generations), m_population_size(population_size), m_breeding_size(breeding_size);

        void dynamic_simulation();
        void crossover();
        void selection();
        const std::vector<Agent> run();

}