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

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

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
