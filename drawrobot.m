%
% drawrobot
%
% Draws a representation of the robot and its orientation
%
% Inputs:   r_robot - radius of robot
%             centre_x - centre of the robot
%             centre_y - centre of robot
%             psi_rad - angle robot is at
%
% NOTE: based on draw_robot code in simulation
%
% Author: Kevin J Worrall
%
% Changes
%       20140424 - KJW  - Swapped x and y coordinates around       
%                       - Altered format of Changes 
%       20060313 - KJW  - File Created
%

function drawrobot(r_robot,centre_x,centre_y,psi_rad,colour),

% Variables needed
end_x=0;
end_y=0;

% Generate Circle
th=linspace(0,2*pi,360);
x_points=r_robot*cos(th);
y_points=r_robot*sin(th);

% Calculate end points of the line
% line is 0.02m larger than the robot
end_x=(cos(psi_rad)*(r_robot+0.02));
end_y=(sin(psi_rad)*(r_robot+0.02));


% Draw robot
% Draw circle
plot((x_points+centre_x),(y_points+centre_y),colour);
% Draw line
line([centre_x,(end_y+centre_x)],[centre_y,(end_x+centre_y)],'color',colour);