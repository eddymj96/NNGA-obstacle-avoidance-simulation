#pragma once
#include <Eigen/Dense>

class motor 
{
    private:
        // -------- Motor Specifications --------
        const float Ra = 4;                         // Resistance of motor, Ohms
        const float La = 0.1;                       // Inductance of motor, H
        const float Kt = 0.35;                      // Torque constant, Nm/A
        const float Ke = 0.35;                      // EMF constant, V/rad/s
        const float bs = 0.008;                     // Viscous torque, Nm 
        const float Jm = 0.005;                     // Moment of Inertia for motor, kg m^2


        const float fric_constant;                  // Friction acting on the wheel, Nm
        // -------- State Variables --------
        float I; // Current, Amps
        float w; // Angular velocity, rad/s
        float t; // Torque, Nm
    
    public:
        motor(const float current, const float ang_velo, const float torque, const float frict);
        Vector3f update(const float &v_desired, const float &stepsize);
        Vector3f get_states();
        void set_states(Vector3f &states);

    

}