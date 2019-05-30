#include "motor.h"
#include <cmath>

motor::motor(const float current, const float ang_velo, const float torque, const float frict) :
I(current), w(ang_velo), t(torque), fric_constant(frict + 0.002)
{

}

Vector3f motor::update(const float &v_desired, const float &stepsize)
{
    const float tau_friction = fric_constant*w;

    Vector3f Xdot_motor;
    const float Idot = ((-Ra*I)-(Ke*w)+ Va)/La;              //  di/dt 
    const float wdot = ((Kt*I)-(bs*w)-tau_friction)/Jm;      // Angular Acceleration

    const eff = (std::abs(I)*-0.1330)+0.6; // Unsure where the "magic" numbers come from

    const float tdot = ((v_desired == 0) ? (-t)/stepsize : (Kt*I*eff-t)/stepsize); // dT/dt

    Xdot_motor << Idot, wdot, tdot;

    return Xdot_motor;
}

Vector3f motor::get_states()
{
    Vector3f states;

    states << I, w, t;
    
    return states;
}

void motor::set_states(Vector3f &states)
{
    I = states(0);
    w = states(1);
    t = states(2);
}