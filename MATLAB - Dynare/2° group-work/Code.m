%--------------------------------------------------------------------------
% AMACRO 2024 -   Problem set 2
%--------------------------------------------------------------------------
% This m-file does the follwing: 
%   1. Runs Dynare to obtain policy functions
%   2. Simulates the economy given the policy functions
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

close all
clear all
clc

% Run Dynare to obtain policy functions

dynare del_0_015.mod 
dynare cps2.mod noclearall


X = [oo_.dr.ys';oo_.dr.ghx';oo_.dr.ghu'];        % create a matrix collecting coefficients of the policy function, whose first row is the variables' steady-state
                 % remember to check the order of the coefficients (compare
% them with the dynare output)
figure;
subplot(2,2,1);
plot(oo_.irfs.y_eps); hold on; plot(oo_.irfs.Y_eps_z); hold off; legend("delta=0.015","delta=0.025");title("Y");
subplot(2,2,2); 
plot(oo_.irfs.k_eps); hold on; plot(oo_.irfs.K_eps_z); hold off; legend("delta=0.015","delta=0.025");title("K");
subplot(2,2,3); 
plot(oo_.irfs.c_eps); hold on; plot(oo_.irfs.C_eps_z); hold off; legend("delta=0.015","delta=0.025");title("C");
subplot(2,2,4); 
plot(oo_.irfs.z_eps); hold on; plot(oo_.irfs.Z_eps_z); hold off; legend("delta=0.015","delta=0.025"); title("Z");
%--------------------------------------------------------------------------
%% 1. Computing impulse response functions
%--------------------------------------------------------------------------

s  = 0.1;            %Standard deviation of the shock
Ti = 40;             %Length of the series, i.e. horizon 

% TFP Shock series:
ei    = zeros(Ti,1);  % vector of zeros with a number of row equal to 40
ei(2) = s;         % the second element of the vector, i.e. the only one =/= 0 is the standard deviation of the shock

% defining variables
% Reserving space, i.e. we define the length of the (column) vectors:
y = zeros(Ti,1);
k = zeros(Ti,1);
c = zeros(Ti,1);
z = zeros(Ti,1);

%Initial values: select the steady states in X (remember that they're in
%the first row)
y(1,1) = X(1,1); 
k(1,1) = X(1,3);
c(1,1) = X(1,2);
z(1,1) = X(1,4);


%Recursion that computes simulated data using the shock series and the
%policy functions:

for t = 2:Ti

    y(t,1) = X(1,1)+X(2,1)*(k(t-1)-X(1,3))+X(3,1)*(z(t-1)-X(1,4))+X(4,1)*ei(t);
    k(t,1) = X(1,3)+X(2,2)*(k(t-1)-X(1,3))+X(3,2)*(z(t-1)-X(1,4))+X(4,2)*ei(t);
    c(t,1) = X(1,2)+X(2,4)*(k(t-1)-X(1,3))+X(3,4)*(z(t-1)-X(1,4))+X(4,4)*ei(t);
    z(t,1) = X(1,4)+X(2,3)*(k(t-1)-X(1,3))+X(3,3)*(z(t-1)-X(1,4))+X(4,3)*ei(t);
end

 figure;
   subplot(2,2,1);
   plot(y);
   subplot(2,2,2);
   plot(k);
   subplot(2,2,3);
   plot(z);
   subplot(2,2,4);
   plot(c);

yss = ones(Ti, 1) * y(1,1);
kss = ones(Ti, 1) * k(1,1);
css = ones(Ti, 1) * c(1,1);
zss = ones(Ti, 1) * z(1,1);

checkY = [y-yss,oo_.irfs.Y_eps_z'];
checkK = [k-kss,oo_.irfs.K_eps_z'];
checkC = [c-css,oo_.irfs.C_eps_z'];
checkZ = [z-zss,oo_.irfs.Z_eps_z'];


%----------------------------------------------------------------------
%% 2. Simulating the economy given policy functions
%----------------------------------------------------------------------
    
    s = 0.1;             %Standard deviation of the shock
    T = 1000;            %Length of the series
    D = 100;          %Discarded periods in the beginning
  
    %Shock series:
    randn('seed',666);   % fixing random seed
    ein = s*randn(T,1);
   
   

    % defining variables
    % Reserving space:
    yn = zeros(T,1);
    kn = zeros(T,1);
    cn = zeros(T,1);
    zn = zeros(T,1);
    
    %Initial values: select the steady states in X
     yn(1,1) = X(1,1);  
     kn(1,1) = X(1,2);
     cn(1,1) = X(1,3);
     zn(1,1) = X(1,4);
     
     
    %Recursion that computes simulated data using the shock series and the
    %policy functions:

   for t = 2:T

    yn(t,1) = X(1,1)+X(2,1)*(kn(t-1)-X(1,3))+X(3,1)*(zn(t-1)-X(1,4))+X(4,1)*ein(t);
    kn(t,1) = X(1,3)+X(2,2)*(kn(t-1)-X(1,3))+X(3,2)*(zn(t-1)-X(1,4))+X(4,2)*ein(t);
    cn(t,1) = X(1,2)+X(2,4)*(kn(t-1)-X(1,3))+X(3,4)*(zn(t-1)-X(1,4))+X(4,4)*ein(t);
    zn(t,1) = X(1,4)+X(2,3)*(kn(t-1)-X(1,3))+X(3,3)*(zn(t-1)-X(1,4))+X(4,3)*ein(t);   

   end

   yn = yn(D+1:end);
   kn = kn(D+1:end);
   cn = cn(D+1:end);
   zn = zn(D+1:end);
   
   datanew = [yn,kn,cn,zn];
   covariance_matrix = cov(datanew);
   mean_of_data = mean(datanew);

   figure;
   subplot(2,2,1);
   plot(yn); title("y");
   subplot(2,2,2);
   plot(kn); title("k");
   subplot(2,2,3);
   plot(zn); title("z");
   subplot(2,2,4);
   plot(cn); title("c");
    
   
       