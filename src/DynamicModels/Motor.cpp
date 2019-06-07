#include "motor.h"
#include <cmath>

Motor::Motor(const float current, const float ang_velo, const float torque, const float frict) :
I(current), w(ang_velo), t(torque), fric_constant(frict + 0.002)
{

}

Eigen::Vector3f Motor::update(const float &v_desired, const float &stepsize)
{
    const float tau_friction = fric_constant*w;

    Eigen::Vector3f Xdot_motor;
    const float Idot = ((-Ra*I)-(Ke*w)+ Va)/La;              //  di/dt 
    const float wdot = ((Kt*I)-(bs*w)-tau_friction)/Jm;      // Angular Acceleration

    const float eff = (std::abs(I)*-0.1330)+0.6; // Unsure where the "magic" numbers come from

    const float tdot = ((v_desired == 0) ? (-t)/stepsize : (Kt*I*eff-t)/stepsize); // dT/dt

    Xdot_motor << Idot, wdot, tdot;

    return Xdot_motor;
}

Eigen::Vector3f Motor::get_states()
{
    Eigen::Vector3f states;

    states << I, w, t;
    
    return states;
}

void Motor::set_states(Eigen::Vector3f &states)
{
    I = states(0);
    w = states(1);
    t = states(2);
}