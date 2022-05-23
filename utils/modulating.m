function kappa = modulating( t , m)
% modulating: modulating function of order m
% call modulating( 'init' , m) to initialise the function parameters
% which are essentially polynomial coefficients
% After that just call modulating(t/T) (vector friendly) which is a 
% curve kappa starting at kappa(0)=0, ending at kappa(T)=1 and with 
% its first m derivatives vanishing at t in {0,T}.

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.


persistent kappa_func;
if ischar(t)
    if strcmp(t,'init')
        A = [ zeros(m-1,1), eye(m-1) ; zeros(1,m) ];
        B = [zeros(m-1,1); 1];
        syms tvar;
        arg = (expm(A*tvar)*B)*(B'*transpose(expm(A*tvar)));
        W = double(subs( int(arg) , 1 ));
        kf = [1; zeros(m-1,1)];
        kappa_func = B'*(expm(A'*(1-tvar))*inv(W))*kf;
        for i = 1 : m
            kappa_func  =int(kappa_func);
        end
        %kappa_func = vpa(kappa_func,2);
        kappa_func = matlabFunction(kappa_func);
    end
else
    if numel(kappa_func) ~= 0
        t(t>1) = 1;
        kappa = kappa_func(t);
    else
        error('modulating not initialised. Call modulating(''init'', m) first' );
    end
end
end

