#pragma once
#include <map>


namespace dynamic
{
    // LIST OF ALL ENV_STATES THAT FORM THE INTERFACE BETWEEN ALL DYNAMIC MODELS AND ENVIRONMENTS
    enum class ENV_STATES 
    {
      GRAVITY,
      DRAG_COEFF,
      AIR_DENSITY
    
    };
    class SharedState
    {
      public:
        float m_value;
        ENV_STATES m_env_state;
        SharedState(ENV_STATES env_state) : m_env_stat(env_state){};
    }   

    
}
