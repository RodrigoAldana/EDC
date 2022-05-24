function kappa = modulating( t , m)
% modulating: modulating function of order m
% call modulating( 'init' , m) to initialise the function parameters
% which are essentially polynomial coefficients
% After that just call modulating(t/T) (vector friendly) which is a 
% curve kappa starting at kappa(0)=0, ending at kappa(T)=1 and with 
% its first m derivatives vanishing at t in {0,T}.

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
persistent kappa_func;
% If the function was called in init mode...
if ischar(t)
    if strcmp(t,'init')
        % ...then compute the polynomial. This is, compute the 
        % grammian control form  (its m-th derivative)to get 
        % the state from [0,...,0] to [1,0,..,0]
        A = [ zeros(m-1,1), eye(m-1) ; zeros(1,m) ];
        B = [zeros(m-1,1); 1];
        syms tvar;
        arg = (expm(A*tvar)*B)*(B'*transpose(expm(A*tvar)));
        W = double(subs( int(arg) , 1 ));
        kf = [1; zeros(m-1,1)];
        kappa_func = B'*(expm(A'*(1-tvar))*inv(W))*kf;
        % Integrate the (m+1)-th derivative, m times
        for i = 1 : m
            kappa_func  =int(kappa_func);
        end
        % Convert the symbolic expresion to matlab function for 
        % its use later
        kappa_func = matlabFunction(kappa_func);
    end
else
    % If the function was not called in init mode, and the function
    % is initialised, then...
    if numel(kappa_func) ~= 0
        % ...compute the polynomial value if t<1. Otherwise, return 1
        t(t>1) = 1;
        kappa = kappa_func(t);
    else
        error('modulating not initialised. Call modulating(''init'', m) first' );
    end
end
end

