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
                
                                 
                x_m = (x_int1 - x_int2)/2; 
                y_m = (y_int1 - y_int2)/2;
                
                % Wall edges
                x_limits = [x1, x2];
                y_limits = [y1, y2];
                        
                % Left most and right most edges respectively
                        
                [xLeft, I1] = min(x_limits);
                [xRight, I2] = max(x_limits);
                        
                leftEdge = [x_limits(I1), y_limits(I1)];
                rightEdge = [x_limit(I2), y_limits(I2)];
              
                
                if (r*dr)^2 - D^2 > 0  % Discriminant, postive = intersections, negative = no intersections
                
                    x_int1 = (D*dy + sign(dy)*dx*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    x_int2 = (D*dy - sign(dy)*dx*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);

                    y_int1 = (-D*dx + abs(dy)*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    y_int2 = (-D*dx - abs(dy)*sqrt(((r^2)*(dr^2)) - D^2))/(dr^2);
                    
                    x_array = [x_int1, x_int2];
                    y_array = [y_int1, y_int2];
                    
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
                        x12 = (c2 - c1)/(m1 - m2)
                        y12 = m1*x12 + c1;
                        
                        % Intersection of line 1 and 3
                        x13 = (c3 - c1)/(m1 - m3);
                        y13 = m1*x13 + c1;
       
                        
%                         if norm([x1, y1]) < r && obj.VectorAngle(headingVector, [x1, y1]) < obj.alpha
%                             LeftLimit 
%                         end

                       LeftLine = atan2(y12/x12) == obj.alpha && norm([x12, y12]) < r;
                       RightLine = atan2(y13/x13) == obj.alpha && norm([x13, y13]) < r;
                       
                       [x_min, Imin] = min(x_array);
                       [x_max, Imax] = max(x_array);
 
                       arcSection_1 = all([r*cos(pi/2 + obj.alpha), r*sin(pi/2 + obj.alpha)] < [x_array(Imin), y_array(Imin)]); 
                       arcSection_1 = arcSection_1 && all([x_array(Imin), y_array(Imin)] < [r*cos(pi/2 - obj.alpha), r*sin(pi/2 - obj.alpha)]);
                            
                       arcSection_2 = all([r*cos(pi/2 + obj.alpha), r*sin(pi/2 + obj.alpha)] < [x_array(Imax), y_array(Imax)]); 
                       arcSection_2 = arcSection_2 && all([x_array(Imax), y_array(Imax)] < [r*cos(pi/2 - obj.alpha), r*sin(pi/2 - obj.alpha)]);
                       
                       
                       if LineSection && arcSection_1
                           arcLimits = [x12, y12l; x_array(Imin), y_array(Imin)];

                       elseif LineSection && arcSection_2
                           arcLimits = [x12, y12l; x_array(Imax), y_array(Imax)];
                           
                       elseif RightLine && arcSection_1 
                           arcLimits = [x13, y13; x_array(Imin), y_array(Imin)];
   
                       elseif RightLine && arcSection_2
                           arcLimits = [x13, y13; x_array(Imax), y_array(Imax)];

                       elseif LeftLine && RightLine
                           arcLimits = [x12, y12; x13, y13]

                       elseif arcSection_1 && arcSection_2
                           arcLimits = [x_array(Imin), y_array(Imin); x_array(Imax), y_array(Imax)];
    
                       else
                           output = [1, 1];
                           return
                       end
                       
                       [LeftIntersection, Ilb]  = min(arcLimits(:, 1));
                       [RightIntersection, Irb] = max(arcLimits(:, 1));
                           
                       leftBounds = arcLimits(Ilb, :);
                       rightBounds = arcLimits(Irb, :);
                       
                       if leftEdge(1) > RightIntersection || rightEdge(1) < LeftIntersection
                           output = [1, 1];
                           return
                       end
                       
                       [LB, IBL] =  max([LeftIntersection, leftEdge(1)]);
                       [RB, IBR] =  min([RightIntersection, rightEdge(1)]);
                       
                       if LB < x_m && x_m < RB
                           output = [x_m, y_m]
                       else
                           if norm(
                               )
                       

%                         if norm([x12, y12]) <= r && obj.VectorAngle(headingVector, [x12, y12]) < pi/2
%                             
%                             if norm()
%                             
%                             if norm(leftEdge) <= r && obj.VectorAngle(headingVector, leftEdge) < obj.alpha
%                                 LeftLimit = leftEdge;                          
%                             else
%                                 LeftLimit = [x12, y12];
%                             end
%                         end
%                         
%                         if norm([x13, y13]) <= r && obj.VectorAngle(headingVector, [x13, y13]) < pi/2
%                             if norm(rightEdge) <= r && obj.VectorAngle(headingVector, rightEdge) < obj.alpha
%                                 RightLimit = rightEdge;
%                             else
%                                 RightLimit = [x12, y12];
%                             end
%                         end
%                         
%                         % New limits based on sensor cone geoemetry limits 
%                         x_array = max([LeftLimit(1), RightLimit(1)], 0);
%                         y_array = max([LeftLimit(2), RightLimit(2)], 0);
%                         
%                         edgeVectorLeft = [x_m - x_array(1), y_m - y_array(1)];
%                         edgeVectorRight = [x_m - x_array(2), y_m - y_array(2)];
%                         
%                         leftDirVector = [x_limits(I2) - x_limits(I1),y_limits(I2) - y_limits(I1)];
%                         rightDirVector = -leftDirVector;
%                         
%                         wallVectorLeft = [x_m - x_limits(I1),y_m - y_limits(I1)];
%                         wallVectorRight = [x_m - x_limits(I1),y_m - y_limits(I1)];
%                        

%                         if x_array(1) > objMax || x_array(2) < objMin
%                             % Wall lies outside of range
%                             output = [1, 1];
%                         else
%                             
%                             if objMin > x_array(1)
%                                 x_array(1) = x_limits(I1);
%                                 y_array(1) = y_limits(I1);
%                             elseif objMax < max(x_limits)
%                                 x_array(2) = x_limits(I2);
%                                 y_array(2) = y_limits(I2);
%                             end
%                             
%                             
%                         end
          
                    end
                   output = [x_array(2), y_array(2)];

                    
                else
                    output = [x1, y1];
                end
                    
                line([x1, x2], [y1, y2]);
                plot(x12, y12, '+')
                plot(x13, y13, '+')
                
           end
            
            
        end
            
        function angle =  VectorAngle(obj, v1, v2)
            angle = acos(dot(v1, v2)/(norm(v1)*norm(v2)));
        end
        
        function curl = Curl2D(v1, v2)
            curl = det([v1;v2]);
        end
        
        end
    
        
end