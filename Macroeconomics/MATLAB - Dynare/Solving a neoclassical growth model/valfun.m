function val=valfun(k) 
% This program gets the value function for a neoclassical growth model with
% no uncertainty and CRRA utility

global a0 prob_mat v0 beta delta alpha kmat k0 s amat q j

%you need to premultiply g by the prob matrix

%we need to use the interpolation for some reason i didn't understand
g = interp1(kmat,v0,k,'linear'); % interpolate values of the value function off of the grid
c = a0*k0^alpha - k + (1-delta)*k0; % consumption, you have to add a0
if c<0
    val = -888888888888888888-800*abs(c); % keeps it from going negative
else
    val=(1/(1-s))*(c^(1-s)-1) + beta*g*prob_mat(j,:)'; %if s=1 val=log(c) + beta*g*prima riga di prob; 
end
val = -val; % make it negative since we're maximizing and code is to minimize.