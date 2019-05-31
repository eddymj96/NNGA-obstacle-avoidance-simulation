#pragma once
#include "Agent.h"
#include "DynamicInterface.h"
#include "Mutatable.h"
#include "NeuralNet.h"
#include <map>
#include <string>

typedef Eigen::Matrix<float, 12, 1>  Vector12f;
typedef std::function<Vector12f(Eigen::Vector12f, Eigen::Vector12f, float)> INTEGRATION_FUNCTION;

class WheeledRobot : public Agent
{
    private:
        // -------- Vehicle States -------- 
        enum VehicleStates
        {
            u, v, w, p, q, r, x, y, z, phi, theta, psi
        };
    
        // -------- Robot Specifications -------- 
        const static float m = 2.148;          // Mass of robot, kg
        const static float wheel_r = 0.0635;   // Radius of Wheel, m
        const static float x_area = 0.0316;    // Area presented on the x-axis, m.m
        const static float y_area = 0.0448;    // Area presented on the y-axis, m.m
        const static float Jx = 0.0140;        // Moment of Inertia about the x-axis, kg.m.m
        const static float Jy = 0.0252;        // Moment of Inertia about the y-axis, kg.m.m
        const static float Jz = 0.0334;        // Moment of Inertia about the z-axis, kg.m.m
        const static float mr = 0.1245;        // Moment Arm

        // -------- Dampening Terms --------
        const static float fric_k = 0.35;
        const static float fric_m = 0.44;
        const static float fric_x = 0.22;
        const static float fric_n = 0.18;
        const static float fric_y = 1;
        const static float fric_z = 0.3;

        // -------- Variable Robot Properties --------

        NeuralNet m_net; 

        std::vector<Motor> m_motors;

        Sensor m_arc_sensor;
        
        Vector12f m_states;

        INTEGRATION_FUNCTION m_integration_func;
        
        vector3f m_p_axis;       
    
    // -------- Environment Specifications -------- 
        dynamic::SharedState g(dynamic::ENV_STATES GRAVITY);           // Gravity, m/s^2
        dynamic::SharedState Cd(dynamic::ENV_STATES DRAG_COEFF);          // Drag Coefficent
        dynamic::SharedState rho(dynamic::ENV_STATES AIR_DENSITY);          // Air density

    public:
    // Default initialisation values, specified at implementationt time so that new robots can be spawned wth same initial conditions
        static bool initialisation_var;
        static Eigen::Matrix2f init_v_inputs; 
        static std::vector<Motors> init_motors; 
        static Sensor init_arc_sensor;
        static Vector12f init_states;
        static Eigen::Vector3f init_p_axis;

        WheeledRobot(NeuralNet m_net)
        Vector12f update_motors(Matrix2f &v_inputs);
        Vector12f update_robot();
        void update(const Eigen::Matrix2f v_inputs, const float stepsize);
        void add_env_params(std::map<dynamic::ENV_STATES, float> &map);
        // Agent overloaded functions
        const std::unique_ptr<Mutable> expose_mutatable();
        const std::unique_ptr<Agent> crossover(const std::vector<std::unique_ptr<Agent>> &parents);
        void mutate();
        VectorXf interact(Environment env);

        
}