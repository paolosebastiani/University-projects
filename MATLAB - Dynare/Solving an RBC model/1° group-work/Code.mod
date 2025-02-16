// Paolo Sebastiani
// AMACRO, 2024 - Problem set 1

// Variables block 
var C Y K Z;
varexo epsilon_z;

// Parameters block
parameters alpha beta delta rho sigma;

alpha=0.3;
beta=0.99;
delta=0.025;
sigma=3;
rho=0.9;

// Model block
model;
C^(-sigma)=beta*(C(+1)^(-sigma)*(alpha*Z(+1)*K^(alpha-1)+(1-delta)));
C + K = Z*(K(-1)^alpha)+(1-delta)*K(-1);
Z=(1-rho)+rho*Z(-1)+epsilon_z;
Y=Z*(K^alpha);
end;

// Steady state block
initval;
Z=1;
K=((1-beta+(beta*delta))/(beta*alpha))^(1/(alpha-1));
C=K*((K^(alpha-1))-delta);
end;

steady;
check;

// Shocks block
shocks;
var epsilon_z; stderr 0.1;
end;

// Solution block 
stoch_simul(order=1,IRF=40);
save epsilon_z.mat;