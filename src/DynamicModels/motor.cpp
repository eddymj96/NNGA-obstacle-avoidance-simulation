#include "motor.h"

motor::motor(const float current, const float ang_velo, const float torque, const float frict) :
I(current), w(ang_velo), t(torque), fric_constant(frict + 0.002)
{

}

motor::update(const float &v_desired, const float &stepsize)
{

}