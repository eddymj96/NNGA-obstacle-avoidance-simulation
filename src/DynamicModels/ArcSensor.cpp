#include "ArcSensor.h"
#include <stdexcept>

ArcSensor::ArcSensor(const float &sensor_pos, const float &angle_limit, const float &distance_limit) : 
m_sensor_pos(sensor_pos), m_angle_limit(angle_limit), m_distance_limit(distance_limit)
{

}

ArcSensor::detect(std::vector<float> sensor_states, Environment &env)
{
    if(env.get_obstacle_no() == 0)
    {
        std::throw("No obstacles in environment for ArcSensor to detect");
    }

    if(sensor_states.size() != 3)
    {
        std::throw("Too many sensor states passes to ArcSensor");
    }


    const float x_pos = sensor_states[0] + m_sensor_pos;
    const float y_pos = sensor_states[1];
    const float psi = sensor_states[2]; // Heading

    const float pi = std::atan(1)*4;

    Eigen::Matrix2f rotation_matrix;

    rotation_matrix << std::cos(psi-pi/2), -std::sin(psi-pi/2), 
                         std::sin(psi-pi/2),  std::cos(psi-pi/2);
  

    std::vector<std::unique_ptr<Obstacle>> wall_obstacles = env.get_obtacles();



    typedef Eigen::Matrix<float, wall_obstacles.size(), 1>  VectorWall

    VectorWall starting_x;
    VectorWall  end_x;

    VectorWall  starting_y;
    VectorWall  end_y;

    for(int i=0;i<wall_obstacles.size();++i)
    {
        starting_x[i] = wall_obstacles[i]->get_starting_x();
        end_x[i] = wall_obstacles[i]->get_end_x();

        starting_y[i] = wall_obstacles[i]->get_starting_y();
        end_y[i] = wall_obstacles[i]->get_end_y();
    }


    // Transform in to relative coordinates 

    VectorWall x1_dif = starting_x - xpos;
    VectorWall x2_dif = end_x - xpos;

    VectorWall y1_dif = starting_y - ypos;
    VectorWall y2_dif = end_y - ypos;

    Eigen::Matrix<float, wall_obstacles.size(), 2> vec1;
    vec1.row(0) = x1_diff;
    vec1.row(1) = y1_diff;

    Eigen::Matrix<float, wall_obstacles.size(), 2> vec2;
    vec2.row(0) = x2_diff;
    vec2.row(1) = y2_diff;

    Eigen::Matrix<float, wall_obstacles.size(), 2> coordinate1 = vec1*rotation_matrix;
    Eigen::Matrix<float, wall_obstacles.size(), 2> coordinate2 = vec2*rotation_matrix;

    // Begin line intersection 
    
    VectorWall dx = coordinate2.row(0) - coordinate1.row(0);
    VectorWall dy = coordinate2.row(1) - coordinate1.row(1);
    
    // Norm of all obstacles
    VectorWall dr = (dx.cwiseProduct(dx) + dy.cwiseProduct(dy)).cwiseSqrt();
    // Determinant of all obstacles
    VectorWall D = coordinate1.row(0).cwiseProduct(coordinate2.row(1)) - coordinate2.row(0).cwiseProduct(coordinate2.row(0));

    // Wall edges
    Eigen::Matrix<float, wall_obstacles.size(), 2>::Index minXIndex;
    Eigen::Matrix<float, wall_obstacles.size(), 2>::Index minYIndex;

    VectorWall x_limits;
    x_limits <<  (Eigen::Matrix<float, wall_obstacles.size(), 2> << coordinate1.row(0), coordinate2.row(0)).rowwise().minCoeff(&minXIndex);
    VectorWall y_limits;
    y_limits <<  (Eigen::Matrix<float, wall_obstacles.size(), 2> << coordinate1.row(1), coordinate2.row(1)).rowwise().minCoeff(&minYIndex);


    Eigen::Matrix<float, wall_obstacles.size(), 2> left_edge;
    Eigen::Matrix<float, wall_obstacles.size(), 2> right_edge;

    left_edge.row(0) = x_limits;
    





}