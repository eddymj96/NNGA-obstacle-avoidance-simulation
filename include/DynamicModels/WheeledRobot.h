#pragma once
#include "Agent.h"
#include "DynamicInterface.h"
#include <Eigen/Dense>
#include <map>
#include <string>

typedef Eigen::Matrix<float, 12, 1>  Vector12f;
typedef std::function<float(Eigen::Vector12f)> INTEGRATION_FUNCTION;


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
        //float W = 21.0719;        // m*g Weight

    public:
        WheeledRobot(NeuralNet m_net, Eigen::Matrix2f v_inputs, std::vector<Motors> motors, Sensor arc_sensor, Vector12f states, Eigen::Vector3f p_axis)
        Vector12f update_motors();
        Vector12f update_robot();
        void update();
        void add_env_params(std::map<dynamic::ENV_STATES, float> &map);
        // Agent overloaded functions
        const std::unique_ptr<Agent> crossover();
        void mutate();
}