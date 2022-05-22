function dX = dyn_redcho( t,x )
global D;

global m; % system order
global k; % system gains
global g;

global freq;
global amp;
global phase;

u = amp.*cos(freq*t+phase);% compute all time varyng signals
n = size(D,1);             % number of agents
X = reshape(x,n,m);        % reshape state: one row per agent, m components for each agent
dX = zeros(size(X));       % placeholder for the dynamics

Y0 = u - X(:,1);     % compute all outputs in one step
for mu = 1 : m-1     % for each mu-th state compute \dot{X}_\mu
    % both integrator dynamics and correction terms
    dX(:,mu) = ...
        + X(:,mu+1)...
        + k(mu)*D*( abs(D'*Y0).^( (m-mu)/m ).*sign(D'*Y0)  )...
        - g(mu)*(X(:,mu));
end

% last state doesnt have integrator dynamics, and correction term is
% discontinous, i.e. sliding mode
dX(:,m) = ...
    + k(m)*D*sign(D'*Y0)...
    - g(m)*X(:,m);

% rearrange again as stacked vector
dX = dX(:);
end

