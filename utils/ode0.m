function [t,x] = ode0(sys, inter,x0,h)
% ode0 : Euler method implementation of differential equation solver
% INPUT:
%   sys:   function which computes dx/dt as a function of x,t. i.e. dx/dt =
%          sys(x,t)
%   inter: time interval to obtain solution
%   x0:    initial condition
%   h:     discretization time step

%% Copyright (C) 2022 Rodrigo Aldana-López <rodrigo.aldana.lopez at gmail dot com> (University of Zaragoza)
% For more information see <https://github.com/RodrigoAldana/EDC/blob/master/README.md>
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%
t = inter(1):h:inter(end);
x = zeros(numel(t), numel(x0));
x(1,:) = x0';

for index = 2 : numel(t)
    print_progress( t(index),inter,0.01, h);
    x(index,:) = x(index-1,:) + h*sys(t(index),x(index-1,:)')'; % euler method
end

end

