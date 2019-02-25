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

            rotationMatrix = [cos(psi - pi/2), -sin(psi -pi/2); sin(psi -pi/2), cos(psi-pi/2)];
            
            for i = 1:length(obj.ObstacleMatrix)
                
                % Transform in to relative coordinates 
                x1_dif = obj.ObstacleMatrix(i).starting_x - xpos;
                x2_dif = obj.ObstacleMatrix(i).end_x - xpos;
                
                y1_dif = obj.ObstacleMatrix(i).starting_y - ypos;
                y2_dif = obj.ObstacleMatrix(i).end_y - ypos;
                
                coordinate1 = [x1_dif, y1_dif]*rotationMatrix;
                coordinate2 = [x2_dif, y2_dif]*rotationMatrix;
                
                [x1, y1] = deal(coordinate1(1), coordinate1(2));
                [x2, y2] = deal(coordinate2(1), coordinate2(2));
                
                % Begin line intersection 
                
                dx = x2 - x1;
                dy = y2 - y1;
                dr = norm([dx, dy]);
                r = obj.d_limit; % Sensor limit and circle radius 
                
                D = det([x1, x2; y1, y2]);

                % Wall edges
                x_limits = [x1, x2];
                y_limits = [y1, y2];
                        
                % Left most and right most edges respectively
                        
                [xLeft, I1] = min(x_limits);
                [xRight, I2] = max(x_limits);
                        
                leftEdge = [x_limits(I1), y_limits(I1)];
                rightEdge = [x_limits(I2), y_limits(I2)];
              
                
                if (r*dr)^2 - D^2 > 0  % Discriminant, postive = intersections, negative = no intersections
                
                    x_int1 = (D*dy + sign(dy)*dx*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    x_int2 = (D*dy - sign(dy)*dx*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);

                    y_int1 = (-D*dx + abs(dy)*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    y_int2 = (-D*dx - abs(dy)*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    
                    x_array = [x_int1, x_int2];
                    y_array = [y_int1, y_int2];
                    
                                    
                                 
                    x_m = (x_int1 + x_int2)/2; 
                    y_m = (y_int1 + y_int2)/2;
                
                    
                    % Determine Upper Half and if it cuts sensor range
                    headingVector = [0, 1];
                    v1 = [x_int1, y_int1];
                    v2 = [x_int2, y_int2];
                    
                    
                    
                    if (obj.VectorAngle(headingVector, v1) < pi/2 || (obj.VectorAngle(headingVector, v2) < pi/2))
                        % Line intersections
                        m1 = (y2-y1)/(x2-x1);
                        m2 = tan(pi/2 + obj.alpha);
                        m3 = tan(pi/2 - obj.alpha);
                        
                        c1 = y1 - m1*x1;
                        c2 = 0;
                        c3 = 0;
                        
                        % Intersection of lines 1 and 2
                        x12 = (c2 - c1)/(m1 - m2);
                        y12 = m1*x12 + c1;
                        
                        % Intersection of line 1 and 3
                        x13 = (c3 - c1)/(m1 - m3);
                        y13 = m1*x13 + c1;
       
                        
                       %-----Calculating arc intersections as booleans-----
                     
                       
                       
                       %Calculating if intersections occur  along arc line edge
                       LeftLine = round(atan2(y12,x12), 4) == round(pi/2 + obj.alpha, 4) && norm([x12, y12]) < r;
                       RightLine = round(atan2(y13,x13), 4) == round(pi/2 - obj.alpha, 4) && norm([x13, y13]) < r;
                       
                      
                       [x_min, Imin] = min(x_array);
                       [x_max, Imax] = max(x_array);
                       
                       % Calculating if intersections occur on the arc curv
        

                       
                       arcSection_1 = all([r*cos(pi/2 + obj.alpha), r*sin(pi/2 + obj.alpha)] < [x_array(Imin), y_array(Imin)]); 
                       arcSection_1 = arcSection_1 && all([x_array(Imin), y_array(Imin)] < [r*cos(pi/2 - obj.alpha), r]);

                            
                       arcSection_2 = all([r*cos(pi/2 + obj.alpha), r*sin(pi/2 + obj.alpha)] < [x_array(Imax), y_array(Imax)]); 
                       arcSection_2 = arcSection_2 && all([x_array(Imax), y_array(Imax)] < [r*cos(pi/2 - obj.alpha), r]);

                       
                       
                       if LeftLine && arcSection_1
                           arcLimits = [x12, y12; x_array(Imin), y_array(Imin)];

                       elseif LeftLine && arcSection_2
                           arcLimits = [x12, y12; x_array(Imax), y_array(Imax)];
                           
                       elseif RightLine && arcSection_1 
                           arcLimits = [x13, y13; x_array(Imin), y_array(Imin)];
   
                       elseif RightLine && arcSection_2
                           arcLimits = [x13, y13; x_array(Imax), y_array(Imax)];

                       elseif LeftLine && RightLine
                           arcLimits = [x12, y12; x13, y13];

                       elseif arcSection_1 && arcSection_2
                           arcLimits = [x_array(Imin), y_array(Imin); x_array(Imax), y_array(Imax)];
    
                       else
                           output = [1, 1];
                           line([x1, x2], [y1, y2]);
                           plot(x12, y12, '+')
                           plot(x13, y13, '+')
                           return
                       end
                       
                       [LeftIntersection, Ilb]  = min(arcLimits(:, 1));
                       [RightIntersection, Irb] = max(arcLimits(:, 1));
                           
                       leftBounds = arcLimits(Ilb, :);
                       rightBounds = arcLimits(Irb, :);
                       
                       if leftEdge(1) > RightIntersection || rightEdge(1) < LeftIntersection
                           output = [1, 1];
                           line([x1, x2], [y1, y2]);
                           fprintf("Inactive wall region")
                           return
                       end
                       
                       lefts = [leftBounds; leftEdge];
                       rights = [rightBounds; rightEdge];
                       
                       [LB, IBL] =  max(lefts(:, 1));
                       [RB, IBR] =  min(rights(:, 1));
                       
                       if LB < x_m && x_m < RB
                           output = [x_m, y_m];
                       else
                           if norm(lefts(IBL, :) - [x_m, y_m]) < norm(rights(IBR, :) - [x_m, y_m])
                               output = lefts(IBL, :);
                           else
                               output = rights(IBR, :);
                           end
                       end
                               
                       


                      plot(x12, y12, '+')
                      plot(x13, y13, '+')
                    end
                  %output = [x_array(2), y_array(2)];


                    
                else
                    fprintf("No intersection occurred")
                    output = [1, 1];
                end
                    
                line([x1, x2], [y1, y2]);
                plot(output(1), output(2), 'o')
                
           end
            
            
        end
            
        function angle =  VectorAngle(obj, v1, v2)
            angle = acos(dot(v1, v2)/(norm(v1)*norm(v2)));
        end
        
        function curl = Curl2D(obj, v1, v2)
            curl = det([v1;v2]);
        end
        
        end
    
        
end