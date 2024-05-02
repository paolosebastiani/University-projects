% This program uses Value Function Iteration to solve a neoclassical growth
% model with no uncertainty


clc;clear all;close all;

global v0 beta delta alpha kmat k0 s prob_mat a0 q amat j

% set parameters (annual frequency)
s=2; beta=0.95; delta=0.1;alpha=0.33;

% Model
%EE: c^{-sigma}=beta*c'(alpha*k'^{alpha-1}+(1-delta))
%MK: y=c+i
%K: k'=(1-delta)k+i
%CD: y=k^alpha

% Steady state
kstar= (alpha/(1/beta - (1-delta)))^(1/(1-alpha));
cstar = kstar^(alpha) -delta*kstar;
istar = delta*kstar;
ystar = kstar^(alpha);

%Construct a grid ranging between 25% and 175% of K steady state
kgrid=99; 
kmin = 0.25*kstar;
kmax = 1.75*kstar;
grid = (kmax-kmin)/kgrid; %% gridpoints
kmat = kmin:grid:kmax; %vector of gridpoints for endogenous state
kmat = kmat';
[N,n] = size(kmat);
amat = [0.9, 1, 1.1]';
q = size(amat,1);
prob_mat = (1/3)*ones(3,3);

% We guess a value function. For simplicity, a vector of zeros:
v0 = zeros(N,q); 
% tolerance criterion for when to stop searching over value functions
% objective is going to be the norm of the of the absolute value of the
% difference between the value function at two iteration points
tol = 0.01;
maxits = 1000;
dif = 10;
its=0;


% For each value in K, find the K′ that maximizes the Bellman equation given my guess of the value function.
while dif>tol && its < maxits  % keep repeating as long as the difference between value functions is greater than the tolerance
    for j=1:q   
        for i=1:N 
            k0 = kmat(i,1); %first element of kmat
            a0 = amat(j,1);
            %we need to rewrite the value function, we still want to find k1,
            %but given k1 we want a valfunc wich will be stored in row i column
            %j
            k1 = fminbnd(@valfun,kmin,kmax); %finds the argmax of the Bellman equation, given kmin and kmax. k1 is kt+1
            % “fminbnd” assumes a continuous choice set – basically it will search over all values of k1 between “kmin” and “kmax”, which will include points not in the original capital grid
            v1(i,j) = -valfun(k1); % collects the optimized value into the new value function
            k11(i,j) = k1; %finds the policy function associated with this choice
        end
    end
    dif = norm(v1-v0);
    v0=v1;
    its = its+1 
end

% we need to adjust it whit a for loop that
for i=1:N
    con(i,1) = kmat(i,1)^(alpha) - k11(i,1) + (1-delta)*kmat(i,1); 
    polfun(i,1) = kmat(i,1)^(alpha) - k11(i,1) + (1-delta)*kmat(i,1);
end

figure
plot(kmat,v1,'k','Linewidth',1)
xlabel('k')
ylabel('V(k)')

figure
plot(kmat,polfun,'k','Linewidth',1)
xlabel('k')
ylabel('c')


figure
plot(kmat,k11,'k','Linewidth',1)
hold on 
plot(kmat,kmat,':r','Linewidth',1)
xlabel('k')
ylabel('k1')
legend('policy function','45 degree line')
