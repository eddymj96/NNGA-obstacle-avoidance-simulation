classdef PerfectObservationSensor < handle
    properties
        ObstacleMatrix;
        sensorPosition;
        alhpa;
        d_limit;
    end
    
    methods
        function obj = ObservationSensor(ObstacleMatrix, sensorPosition, sensorAngleLimit, sensorDistanceLimit)
            obj.ObstacleMatrix = ObstacleMatrix;
            obj.sensorPosition = sensorPosition;
            obj.alpha = sensorAngleLimit;
            obj.d_limit = sensorDistanceLimit;
        end
        
        function output = detect(x_current, y_current, heading)
            xpos = x_current + obj.sensorPosition; % Assuming the previous referred to this
                                               %"+0.1" was just fixed and not a funciton of input
            ypos = y_current;
            
            theta = ((j-20)*(pi/180))+ psi; % 
            
            
        end
    end
end