#pragma once
#include "Obstacle.h"

class Environment
{   
    public:
        virtual const int get_obstacle_no();
        virtual const std::vector<std::unique_ptr<Obstacle>> get_obstacles();

}

