#include "Robot.h"
#include <cmath>


WheeledRobot::WheeledRobot(NeuralNet net)
: m_net(net), m_motors(init_motors), m_arc_sensor(init_arc_sensor), m_states(init_states), m_p_axis(init_p_axis)
{
    if(!initialisation_var);
        std::throw("Default Wheeled Robot values must be set before instantiation of first object");
    
}

Vector12f WheeledRobot::update_motors()
{
    Vector12f output_states;
    for(int i = 0; i<m_motors.size(), ++i)
    {
        output_states.segment<(3*i + 2)>(3*i) = m_motors[i].update();
    }

    return output_states;
}

Vector12f WheeledRobot::update_robot()
{
    // -------- Setup Cosines and Sines -------- 

    // Cosines
    const float cphi = std::cos(m_states(phi)); 
    const float ctheta = std::cos(m_states(theta)); 
    const float cpsi = std::cos(m_states(psi));

    // Sines
    const float sphi = std::sin(m_states(phi)); 
    const float stheta = std::sin(m_states(theta)); 
    const float spsi = std::sin(m_states(psi));

    // --------  Input Forces -------- 
    // Calculated from the torques generated by the wheels. 
    const float force_l1 = (m_motors[0].get_torque()/wheel_r);
    const float force_l2 = (m_motors[1].get_torque()/wheel_r);
    const float force_r1 = (m_motors[2].get_torque()/wheel_r);
    const float force_r2 = (m_motors[3].get_torque()/wheel_r);

    // -------- Slip -------- 
    // calculates the slip angle for each wheel
    const float bottom = std::sqrt((m_states(u)^2)+(m_states(v)^2));
    const float beta = ((bottom == 0) ? 0 : std::asin(m_states(v)/bottom));

    // -------- Propulsion Forces -------- 
    const float surge = (force_l1+force_l2+force_r1+force_r2)*std::cos(beta);
    const float sway = (force_l1+force_l2+force_r1+force_r2)*std::sin(beta);
    const float roll = m_p_axis[0];
    const float pitch = m_p_axis[1];
    const float heave = m_p_axis[2];
    const float yaw = ((force_l1+force_l2)-(force_r1+force_r2))*mr;

    // --------  Friction -------- 
    const float Fx_fric = m*g.m_value*fric_x*m_states(u);    // W*fric_x*u;
    const float Fy_fric = m*g.m_value*fric_y*m_states(v);    // W*fric_y*v;
    const float Fz_fric = m*g.m_value*fric_z*m_states(w);    // W*fric_z*w;
    const float K_fric = m*g.m_value*fric_k*mr*m_states(p);  // W*fric_k*mr*p;
    const float M_fric = m*g.m_value*fric_m*mr*m_states(q);  // W*fric_m*mr*q;
    const float N_fric = m*g.m_value*fric_n*mr*m_states(r);  // W*fric_n*mr*r;
 
    // --------  Air Resistance -------- 
    // x-axis
    const float Fx_ar = 0.5*Cd.m_value*x_area*rho.m_value*m_states(u)*std::abs(m_states(u)); // 0.5*Cd*x_area*rho*u*abs(u)

    // -------- Total Dampening -------- 
    const float X_damp = Fx_fric+Fx_ar;
    const float Y_damp = Fy_fric;
    const float Z_damp = Fz_fric;
    const float K_damp = K_fric;
    const float M_damp = M_fric;
    const float N_damp = N_fric;

    // -------- Gravity Terms -------- 
    const float X_grav = m*g.m_value*stheta;
    const float Y_grav = m*g.m_value*sphi*ctheta;
    const float Z_grav = (m*g.m_value*ctheta*cphi)-(m*g.m_value);

    // -------- Forces and Torques -------- 
    // Forces
    const float X = surge-X_damp+X_grav;
    const float Y = sway-Y_damp+Y_grav;
    const float Z = heave-Z_damp+Z_grav;
    // Torques
    const float K = roll-K_damp;
    const float M = pitch-M_damp;
    const float N = yaw-N_damp;

    // -------- Equations of Motion -------- 
    // Linear Accelerations
    const float udot = (X/m_states(m))+(m_states(v)*m_states(r))-(m_states(w)*m_states(q));
    const float vdot = (Y/m_states(m))+(m_states(w)*m_states(p))-(m_states(u)*m_states(r));
    const float wdot = (Z/m_states(m))+(m_states(u)*m_states(q))-(m_states(v)*m_states(p));

    // Rotational Accelerations
    const float pdot = (K-((m_states(Jz)-m_states(Jy))*m_states(q)*m_states(r)))/m_states(Jx);
    const float qdot = (M-((m_states(Jx)-m_states(Jz))*m_states(r)*m_states(p)))/m_states(Jy);
    const float rdot = (N-((m_states(Jy)-m_states(Jx))*m_states(p)*m_states(q)))/m_states(Jz);

    // -------- Kinematics -------- 
    // Linear Kinematics
    const float xdot = ((cpsi*ctheta)*m_states(u))+(((-spsi*cphi)-(cpsi*stheta*sphi))*m_states(v))+(((spsi*sphi)-(cpsi*stheta*cphi))*m_states(w)); 
    const float ydot = ((spsi*ctheta)*m_states(u))+(((cpsi*cphi)-(spsi*stheta*sphi))*m_states(v))+(((-sphi*cpsi)-(spsi*cphi*stheta))*m_states(w));
    const float zdot = ((stheta)*m_states(u))+((ctheta*sphi)*m_states(v))+((ctheta*cphi)*m_states(w));

    // Angular Kinematics
    // In theory +/-90 degrees for pitch is undefined but matlab tan()
    // gives it a figure. Also this situation should not occur.
    const float ttheta = std::tan(m_states(theta));
    const float phidot = m_states(p)+((-sphi*ttheta)*m_states(q))+((cphi*ttheta)*m_states(r)); 
    const float thetadot = ((cphi)*m_states(q))+((sphi)*m_states(r));
    const float psidot = ((-sphi/ctheta)*m_states(q))+((cphi/ctheta)*m_states(r));

    // Reassignment 

    Vector12f Xdot;
    Xdot << udot, vdot, wdot, pdot, qdot, rdot, xdot, ydot, zdot, phidot, thetadot, psidot;
            
    return Xdot;
}

WheeledRobot::update(const Eigen::Matrix2f v_inputs, const float stepsize)
{
    const Vector12f Xdot_motor = update_motors(&v_inputs);
    const Vector12f Xdot_robot = update_robot();

    m_states = m_integration_func(m_states, Xdot_robot, stepsize);

    //TODO inneficient implementation, should fix
    Vector12f temp_motor_states;

    for(int i = 0; i<m_motors.size(), ++i)
    {
       temp_motor_states.temp_motor_states.segment<(3*i + 2)>(3*i) = m_motors[i].get_states();
    }

    temp_motor_states = m_integration_func(temp_motor_states, Xdot_motor, stepsize);

    for(int i = 0; i<m_motors.size(), ++i)
    {
       temp_motor_states = m_motors[i].set_states(temp_motor_states.segment<(3*i + 2)>(3*i));
    }

}

const std::unique_ptr<Mutatable> WheeledRobot::expose_mutatable()
{
    return m_net;
}

const std::unique_ptr<Agent> WheeledRobot::crossover(const std::vector<std::unique_ptr<Agent>> &parents)
{
    if (parents.size() == 0);
        std::throw("No Neural Net Parents recieved");

    std::vector<std::unique_ptr<NeuralNet>> neural_parents;

    for(int i=0;i<[parents.size()];++i)
	{
		neural_parents.emplace_back(std::move(parents[i]->expose_mutable()));
	}

    const std::vector<int> layer_formation = parents[0]->expose_mutatable()->get_layer_formation();

    NeuralNet child(layer_formation, neural_parents);

    return std::make_unique<WheeledRobot>(child);
    
}

Eigen::VectorXf interact(Environment &env)
{
    const int ob_no = env.get_obstacle_no();

    if (ob_no == 0);
        std::throw("No obstacles in the environment");

    VectorXf obstacle_readings;
    obstacle_readings = m_arc_sensor.detect(env.get_obstacles());

    return obstacle_readings;
}

