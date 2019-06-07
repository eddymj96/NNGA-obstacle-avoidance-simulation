#pragma once
#include "Sensor.h"

class ArcSensor : public Sensor
{
    public:
        float m_sensor_pos;
        float m_angle_limit;
        float m_distance_limit;
        
        ArcSensor(const float &sensor_pos, const float &angle_limit, const float &distance_limit);
        Eigen::VectorXf detect(std::vector<float> sensor_states, Environment &env);

}