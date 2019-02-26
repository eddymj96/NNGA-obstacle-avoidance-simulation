classdef wallObject < handle
    
    properties 
        starting_x
        starting_y
        end_x
        end_y
        path
    end
    
    methods 
        function obj = wallObject(x_0, y_0, x_1, y_1)
            obj.starting_x = x_0;
            obj.starting_y = y_0;
            obj.end_x = x_1;
            obj.end_y = y_1;
            t = 0:norm([x_1 - x_0, y_1 - y_0])/100:norm([x_1 - x_0, y_1 - y_0]);
            theta = atan((y_1 - y_0)/(x_1 - x_0));
            obj.path = [x_0 + t.*cos(theta); y_0 + t.*sin(theta)];
        end
        
        function plot(obj)
            plot(obj.path(1, :), obj.path(2, :), "k-");
        end
        
        function inversePlot(obj)
            plot(obj.path(2, :), obj.path(1, :), "k-");
        end
    
    end
end