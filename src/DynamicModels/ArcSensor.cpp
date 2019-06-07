#include "ArcSensor.h"
#include <stdexcept>
#include <algorithm>   
#include <iostream> 
#include <cmath>


ArcSensor::ArcSensor(const float &sensor_pos, const float &angle_limit, const float &distance_limit) : 
m_sensor_pos(sensor_pos), m_angle_limit(angle_limit), m_distance_limit(distance_limit)
{

}
// TODO Pretty unreadable will have to be refactored at some point, possibly using Eigen and boolean masks, but it works

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

    Eigen::VectorXf output(2);
    output << 1,1;

    Eigen::Matrix2f rotation_matrix;

    rotation_matrix << std::cos(psi-pi/2), -std::sin(psi-pi/2), 
                         std::sin(psi-pi/2),  std::cos(psi-pi/2);

    Eigen::Matrix2f coordinates; 


    for(int i=0;i<wall_obstacle.size();++i)
    {
        float starting_x = wall_obstacles[i]->get_starting_x();
        float end_x = wall_obstacles[i]->get_end_x();

        float starting_y = wall_obstacles[i]->get_starting_y();
        float end_y = wall_obstacles[i]->get_end_y();

        float x1_dif = starting_x - x_pos;
        float x2_dif = end_x - x_pos;

        float y1_dif = starting_y - y_pos;
        float y2_dif = end_y - y_pos;

        coordinates << x1_dif, y1_dif, x2_dif, y2_dif;

        float x1 = (coordinates*rotation_matrix)(0,0);
        float y1 = (coordinates*rotation_matrix)(0,1);
        float x2 = (coordinates*rotation_matrix)(1,0);
        float y2 = (coordinates*rotation_matrix)(1,1);
        
        // Begin line intersection 
                
        float dx = x2 - x1;
        float dy = y2 - y1;
        float dr = std::sqrt(dx*dx + dy*dy);
                
        float D = x1*y2 - x2*y1;

        //  Wall edges

        int x_index;
                        
        float x_left_edge = coordinates.row(0).minCoeff(&x_index);
        float y_left_edge = coordinates(1, x_index);

        float x_right_edge = coordinates(0, 1-x_index);
        float y_right_edge = coordinates(1, 1-x_index);

        float discriminant = std::pow(r*dr,2) - std::pow(D,2);

        if (discriminant > 0)  // Discriminant, postive = intersections, negative = no intersections
        {
            std::cout << "line intersects" << std::endl;
                
            float x_int1 = (D*dy + ((dy > 0) + (dy < 0))*dx*std::sqrt(discriminant))/(dr*dr);
            float x_int2 = (D*dy + ((dy > 0) - (dy < 0))*dx*std::sqrt(discriminant))/(dr*dr);

            float y_int1 = (-D*dx + std::abs(dy)*std::sqrt(discriminant))/(dr*dr);
            float y_int2 = (-D*dx - std::abs(dy)*std::sqrt(discriminant))/(dr*dr);
                    
            float x_int_left_edge = (x_int1 < x_int2)*x_int1 + (x_int2 < x_int1)*x_int2;
            float y_int_left_edge = (x_int1 < x_int2)*y_int1 + (x_int2 < x_int1)*y_int2;

            float x_int_right_edge = (x_int1 > x_int2)*x_int1 + (x_int2 > x_int1)*x_int2;
            float y_int_right_edge = (x_int1 > x_int2)*y_int1 + (x_int2 > x_int1)*y_int2;

            // mid point of chord, and thus closest point to sensor
                    
            float x_m = (x_int1 + x_int2)/2; 
            float y_m = (y_int1 + y_int2)/2;
                
                  
                    
            // Line intersections
            float m1 = (y2-y1)/(x2-x1);
            float m2 = std::tan(pi/2 + angle_limit);
            float m3 = std::tan(pi/2 - angle_limit);
                        
            float c1 = y1 - m1*x1;
                        
            // Intersection of lines 1 and 2
            float x12 = (-c1)/(m1 - m2);
            float y12 = m1*x12 + c1;
                        
            // Intersection of line 1 and 3
            float x13 = (-c1)/(m1 - m3);
            float y13 = m1*x13 + c1;

            // -----Calculating arc intersections as booleans-----
                     
 
            // Calculating if intersections occur  along arc line edge
            float LeftLine = (std::atan2(y12,x12) == (pi/2 + angle_limit)) && (std::sqrt(x12*x12 + y12*y12) < r);
            float RightLine = (std::atan2(y13,x13) == (pi/2 - angle_limit)) && (std::sqrt(x12*x12 + y12*y12) < r);

            // Calculating if intersections occur on the arc curve
            
            float arcSection_1 =(r*std::cos(pi/2 + angle_limit) < x_int_left_edge) && (r*std::sin(pi/2 + angle_limit) < y_int_left_edge); 
            arcSection_1 = arcSection_1 && (x_int_left_edge < r*std::cos(pi/2 - angle_limit)) && (y_int_left_edge <  r);

            float arcSection_2 =(r*std::cos(pi/2 + angle_limit) < x_int_right_edge) && (r*std::sin(pi/2 + angle_limit) < y_int_right_edge); 
            arcSection_2 = arcSection_1 && (x_int_right_edge < r*std::cos(pi/2 - angle_limit)) && (y_int_right_edge <  r);

            Eigen::Matrix2f arc_limits(2,2);

            if (LeftLine && arcSection_1)
                arc_limits << x12, y12, x_int_left_edge, y_int_left_edge;
            else if (LeftLine && arcSection_2)
                arc_limits << x12, y12, x_int_right_edge, y_int_right_edge; 
            else if (RightLine && arcSection_1)
                arc_limits << x13, y13, x_int_left_edge, y_int_left_edge;
            else if (RightLine && arcSection_2)
                arc_limits << x13, y13, x_int_right_edge, y_int_right_edge; 
            else if (LeftLine && RightLine)
                arc_limits << x12, y12, x13, y13; 
            else if (arcSection_1 && arcSection_2)
                arc_limits << x_int_left_edge, y_int_left_edge, x_int_right_edge, y_int_right_edge; 
            else
            {
              std::cout << "Obstacle region not active" << std::endl;
              continue;
            }
            
            // Check if wall lies within arc region
                      
            float x_left_arc_edge = arc_limits.row(0).minCoeff(&x_index);
            float y_left_arc_edge = arc_limits(1, x_index);

            float x_right_arc_edge = arc_limits(0, 1-x_index);
            float y_right_arc_edge = arc_limits(1, 1-x_index);

            if (x_left_edge > x_right_arc_edge  || x_right_edge  < x_left_arc_edge)
                continue;
            
            std::cout << "Obstacle active" << std::endl;

            
            bool x_max = x_left_arc_edge > x_left_edge;
            float LB_x = (x_max)*x_left_arc_edge + (!x_max)*x_left_edge;
            float LB_y = (x_max)*y_left_arc_edge + (!x_max)*y_left_edge;

            float RB_x = (x_max)*x_right_arc_edge + (!x_max)*x_right_edge;
            float RB_y = (x_max)*y_right_arc_edge + (!x_max)*y_right_edge;

            float test = std::min(output[0], static_cast<float>(1.0));
            
            
            
               
            if (LB_x < x_m && x_m < RB_x) // if closest point is not at arc edges, but inside it
            {
                if(RB_x <= 0) // bounded to the left sensor
                {
                    output[0] = std::min(output[0], std::sqrt(x_m*x_m +y_m*y_m));
                    output[1] = std::min(output[1], static_cast<float>(1.0));
                }
                else if (LB_x >= 0) // bounded to the right sensor
                {
                    output[0] = std::min(output[0], static_cast<float>(1.0));
                    output[1] = std::min(output[1], std::sqrt(x_m*x_m +y_m*y_m));
                }
                else
                {
                    if (x_m <= 0) // across both sensors, min in left sensor therefore right sensor = vertical intersection: c1
                    {
                        output[0] = std::min(output[0], std::sqrt(x_m*x_m +y_m*y_m));
                        output[1] = std::min(output[1], c1);
                    }  
                    else // across both sensors, min in right sensor therefore left sensor = vertical intersection: c1
                    {
                        output[0] = std::min(output[0], c1);
                        output[1] = std::min(output[1], std::sqrt(x_m*x_m +y_m*y_m));
                    }

                }  
                     
            }
            else // closest point is on arc edge
            {
                const float LB_distance = std::sqrt(std::pow(LB_x - x_m, 2)+ std::pow(LB_y - y_m, 2));
                const float RB_distance = std::sqrt(std::pow(RB_x - x_m, 2)+ std::pow(RB_y - y_m, 2));

                if (LB_distance < RB_distance) // LB is closer to minimum distance pt
                {
                    if (RB_x <= 0)
                    {
                        output[0] = std::min(output[0], std::sqrt(LB_x*LB_x + LB_y*LB_y));
                        output[1] = std::min(output[1], static_cast<float>(1.0));
                    } 
                    else if(LB_x >= 0)
                    {
                        output[0] = std::min(output[0], static_cast<float>(1.0));
                        output[1] = std::min(output[1], std::sqrt(LB_x*LB_x + LB_y*LB_y));
                    }
                    else
                    {
                        output[0] = std::min(output[0], std::sqrt(LB_x*LB_x + LB_y*LB_y));
                        output[1] = std::min(output[1], c1);
                    }
                }
                   
                else // RB is closer to minimum distance pt
                {
                    if (RB_x <= 0)
                    {
                        output[0] = std::min(output[0], std::sqrt(RB_x*RB_x + RB_y*RB_y));
                        output[1] = std::min(output[1], static_cast<float>(1.0));
                    } 
                    else if(LB_x >= 0)
                    {
                        output[0] = std::min(output[0], static_cast<float>(1.0));
                        output[1] = std::min(output[1], std::sqrt(RB_x*LB_x + RB_y*RB_y));
                    }
                    else
                    {
                        output[0] = std::min(output[0], c1);
                        output[1] = std::min(output[1], std::sqrt(RB_x*RB_x + RB_y*RB_y));
                    }
                }
            }
            
            
                       
        }               
        
    }

    std::cout << output << std::endl;

    return output;

}