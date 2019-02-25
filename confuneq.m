function [c, ceq] = confuneq(x)
% Nonlinear inequality constraints
c = x(1)^2 + x(2)^2 - 10 ;
% Nonlinear equality constraints
ceq = [];
end