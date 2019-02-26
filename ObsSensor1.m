function sensorout = ObsSensor1(cur_x,cur_y,sensor_pos,psi,Obs_Matrix)

%---------------------------------------------------------------------%
% Define Sensor

sensorout = [0 0];

xpos = cur_x + 0.1;
ypos = cur_y;
%---------------------------------------------------------------------%

%---------------------------------------------------------------------%
% Check for Obstacle
distance  = 0;
cur_nearest_l  = 500;
%for j = 1:41,
for j = 1:21
    for k = 1:100
        sensor_range = k/100;
        
        % Get Point
        theta = ((j-20)*(pi/180))+ psi;
        xpt = round(100*(xpos+(sensor_range*cos(theta))));
        ypt = round(100*(ypos+(sensor_range*sin(theta))));
        
        if(xpt == 0)
            xpt = 1;
        end
        
        if(ypt == 0)
            ypt = 1;
        end
        
        % True x and y
        t_ypt = ypt*0.01;
        t_xpt = xpt*0.01;
        
        % Obs Matrix
        mat_x = uint16(round((t_xpt/0.01)+500));
        mat_y = uint16(round((t_ypt/0.01)+500));

        % Get Value at point
        value = Obs_Matrix(mat_x,mat_y);
        if (value)
          %  plot(t_ypt
            % Calculate nearest distance,t_xpt,'c*');
            
            x_dis = abs(t_xpt)-abs(xpos);
            y_dis = abs(t_ypt)-abs(ypos);
            
            distance = sqrt(x_dis^2+y_dis^2);
            if (distance < cur_nearest_l)
                cur_nearest_l = distance;
            end
   
        end
    end
end

distance  = 0;
cur_nearest_r  = 500;

for j = 21:41
    for k = 1:100
        sensor_range = k/100;
        
        % Get Point
        theta = ((j-20)*(pi/180))+psi;
        xpt = round(100*(xpos+(sensor_range*cos(theta))));
        ypt = round(100*(ypos+(sensor_range*sin(theta))));
        
        if(xpt == 0)
            xpt = 1;
        end
        
        if(ypt == 0)
            ypt = 1;
        end
        
        % True x and y
        t_ypt = ypt*0.01;
        t_xpt = xpt*0.01;
        
        % Obs Matrix
        mat_x = uint16(round((t_xpt/0.01)+500));
        mat_y = uint16(round((t_ypt/0.01)+500));

        % Get Value at point
        value = Obs_Matrix(mat_x,mat_y);
        if (value)
           % plot(t_ypt,t_xpt,'r*');
            
            % Calculate nearest distance
            x_dis = abs(t_xpt)-abs(xpos);
            y_dis = abs(t_ypt)-abs(ypos);
            
            distance = sqrt(x_dis^2+y_dis^2);
            if (distance < cur_nearest_r)
                cur_nearest_r = distance;
            end
        end
    end
end

if(cur_nearest_l > 100)
    cur_nearest_l = 1;
end

if(cur_nearest_r > 100)
    cur_nearest_r = 1;
end

sensorout = [cur_nearest_l cur_nearest_r];
%---------------------------------------------------------------------%

end
