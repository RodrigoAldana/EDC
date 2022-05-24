function print_progress( t,inter,percentage_step,time_step )
% print_progress: Prints percentage of progress for a ode0 
% or other methods whose progress is meassured with respect to a time
% variable running over an interval with a fixed step.
% INPUTS:
%       t:               current time value.
%       inter:           vector containing initial and final times.
%       percentage_step: refers to "how often should progress
%                        be printed? every 1%? every 5?".
%       time_step:       refers to the fixed time step at which the time
%                        variable is expected to increase.

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

persistent local_data;

T = inter(2)-inter(1);

% When t is at the beginning of the interval, we initialize the 
% progress state machine
if(t==inter(1) || t == inter(1)+time_step)
    local_data.state = 0;
    local_data.progress = 0;
end

switch(local_data.state)
    case 0
        % In the initial state, just print the first progress promt
        % and set the first checkpoint at one perceptage_step
        fprintf("\n\n Progress:\n 0%%\n ");
        local_data.state = 1;
        local_data.progress = percentage_step;
    case 1
        
        % Once the progress checkpoint has been reached...
        if(t-inter(1)>T*local_data.progress)
            % ...print the progress and set a new checkpoint
            fprintf("=> %3.1f%%\n ",local_data.progress*100);
            local_data.progress = local_data.progress + percentage_step;
        end
        
        % If t is at the end of the interval, go to an idle state
        if(t>=inter(2)-time_step)
            fprintf("=>100%%. Completed!");
            local_data.state = 2;
        end
end
