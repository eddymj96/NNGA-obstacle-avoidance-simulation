classdef motor < handle 
    properties 
        % Motor Spec's
        Ra = 4;                         % Resistance of motor, Ohms
        La = 0.1;                       % Inductance of motor, H
        Kt = 0.35;                      % torque constant, Nm/A
        Ke = 0.35;                      % EMF constant, V/rad/s
        bs = 0.008;                     % Viscous torque, Nm 
        Jm = 0.005;                     % Moment of Inertia for motor, kg m^2
        fric_constant;% Friction acting on the wheel, Nm
        
        % Dynamic Variables
        I; % Amps
        w; % rad/s
        t; % Nm
        
        % Desired Velocity 
        Va
        
    end
    
    methods
        
        function obj = motor(I, w, t, Va, xtra_fric)
            obj.I = I;
            obj.w = w;
            obj.t = t;
            obj.Va = Va;
            obj.fric_constant = 0.002 + xtra_fric;
        end
        
        function [Idot, wdot, tdot] = update(obj, motorInputs, Va, stepsize, xtra_fric)
            obj.fric_constant = 0.002+xtra_fric; % UpdateFriction
            obj.I = motorInputs(1);
            obj.w = motorInputs(2);
            obj.t = motorInputs(3);
         
            Idot = ((-obj.Ra*obj.I)-(obj.Ke*obj.w)+ Va)/obj.La;              % di/dt 
            tau_friction = obj.fric_constant*obj.w;
            wdot = ((obj.Kt*obj.I)-(obj.bs*obj.w)-tau_friction)/obj.Jm;      % Angular Acceleration

            eff = (abs(obj.I)*-0.1330)+0.6;
            if (Va == 0)
                tdot = (0-obj.t)/stepsize;
            else
                tdot = (obj.Kt*obj.I*eff-obj.t)/stepsize;                          % Torque
            end

        end
            
    end
end