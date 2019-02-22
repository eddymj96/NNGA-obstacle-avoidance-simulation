classdef PerfectObservationSensor < handle
    properties
        ObstacleMatrix;
        sensorPosition;
        alpha;
        d_limit;
    end
    
    methods
        function obj = PerfectObservationSensor(ObstacleMatrix, sensorPosition, sensorAngleLimit, sensorDistanceLimit)
            obj.ObstacleMatrix = ObstacleMatrix;
            obj.sensorPosition = sensorPosition;
            obj.alpha = sensorAngleLimit;
            obj.d_limit = sensorDistanceLimit;
        end
        
        function output = detect(obj,x_current, y_current, heading)
            xpos = x_current + obj.sensorPosition; % Assuming the previous referred to this
                                               %"+0.1" was just fixed and not a funciton of input
            ypos = y_current;
            
            psi = heading;
            rotateRight = [0, 1; -1, 0];
            rotationMatrix = [cos(psi +pi/2), -sin(psi); sin(psi), cos(psi)]%*rotateRight;
            
            for i = 1:length(obj.ObstacleMatrix)
                
                % Transform in to relative coordinates 
                x1_dif = obj.ObstacleMatrix(i).starting_x - xpos;
                x2_dif = obj.ObstacleMatrix(i).end_x - xpos;
                
                y1_dif = obj.ObstacleMatrix(i).starting_y - ypos;
                y2_dif = obj.ObstacleMatrix(i).end_y - ypos;
                
                x_matrix = rotationMatrix*[x1_dif; x2_dif];
                y_matrix = rotationMatrix*[y1_dif; y2_dif];
                
                [x1, x2] = deal(x_matrix(1), x_matrix(2));
                [y1, y2] = deal(y_matrix(1), y_matrix(2));
                
                % Begi lien intersection 
                
                dx = x2 - x1;
                dy = y2 - y1;
                dr = norm([dx, dy]);
                r = obj.d_limit; % Sensor limit and circle radius 
                
                D = det([x1, x2; y1, y2]);
                
                if (r*dr)^2 - D^2 > 0 % Discriminant, postive = intersections, negative = no intersections
                
                    x_int1 = (D*dy + sign(dy)*dx*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    x_int2 = (D*dy - sign(dy)*dx*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);

                    y_int1 = (-D*dx + abs(dy)*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    y_int2 = (-D*dx - abs(dy)*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    
                    x_array = [x_int1, x_int2];
                    y_array = [y_int1, y_int2];
                    
                    % Determine Upper Half and if it cuts sensor range
                    headingVector = [cos(psi), sin(psi)];
                    v1 = [x_int1, y_int1];
                    v2 = [x_int2, y_int2];
                    
                    if (obj.VectorAngle(headingVector, v1) < pi/2 && (obj.VectorAngle(headingVector, v2) < pi/2))
                        % Line intersections
                        m1 = (y2-y1)/(x2-x1);
                        m2 = atan(pi/2 + obj.alpha);
                        m3 = atan(pi/2 - obj.alpha);
                        
                        c1 = y1 - m1*x1;
                        c2 = 0;
                        c3 = 0;
                        
                        % Intersection of lines 1 and 2
                        x12 = (c2 - c1)/(m1 - m2);
                        y12 = m1*x12 + c1;
                        
                        % Intersection of line 1 and 3
                        x13 = (c3 - c1)/(m1 - m3);
                        y13 = m1*x13 + c1;
  

                        
                        x_m = (x_int1 - x_int2)/2; 
                        y_m = (y_int1 - y_int2)/2;
                        
                        [Min, I1] = min(x_array);
                        [Max, I2] = max(x_array);
                        
                        if norm([x12, y12]) < r 
                            LeftLimit = [x12, y12];
                        else
                            LeftLimit = [x_array(I1), y_array(I1)];
                        end
                        
                        if norm([x13, y13]) < r 
                            RightLimit = [x13, y13];
                        else
                            RightLimit = [x_array(I2), y_array(I2)];
                        end
                        
                        % New limits based on sensor cone geoemetry limits 
                        x_array = [LeftLimit(1), RightLimit(1)];
                        y_array = [LeftLimit(2), RightLimit(2)];
                        
                        % Wall edges
                        x_limits = [x1, x2];
                        y_limits = [y1, y2];
                        
                        % Left most and right most edges respectively
                        [objMin, I1] = min(x_limits);
                        [objMax, I2] = max(x_limits);

                        if x_array(1) > objMax || x_array(2) < objMin
                            % Wall lies outside of range
                            output = [1, 1];
                        else
                            
                            if objMin > x_array(1)
                                x_array(1) = x_limits(I1);
                                y_array(1) = y_limits(I1);
                            elseif objMax < max(x_limits)
                                x_array(2) = x_limits(I2);
                                y_array(2) = y_limits(I2);
                            end
                            
                            
                        end
          
                    end
                   output = [x1, y1];

                    
                else
                    output = [x1, y1];
                end
                    

                
           end
            
            
        end
            
        function angle =  VectorAngle(obj, v1, v2)
            angle = acos(dot(v1, v2)/(norm(v1)*norm(v2)));
        end
        
        end
    
        
end