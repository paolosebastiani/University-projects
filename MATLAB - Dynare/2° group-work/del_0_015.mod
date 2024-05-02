//Variables block 
//dynare
//AMACRO, 2024 - Problem set 1
//Need to fill parts marked with <>

var Y C K Z;
varexo eps_z;

//Parameters block
parameters alpha_a beta delta rho sigma sigma_z;


alpha_a= 0.3;
beta=0.99;
delta=0.015;
rho=0.9;
sigma=3;
sigma_z=0.1;


//Model block
model;
exp(Y)=exp(Z)*exp(K(-1))^(alpha_a);
exp(C)^(-sigma)=beta*exp(C(+1))^(-sigma)*(alpha_a*exp(Z(+1))*exp(K)^(alpha_a-1)+(1-delta));
exp(C)+exp(K)=exp(Z)*exp(K(-1))^(alpha_a)+(1-delta)*exp(K(-1));
exp(Z)=(1-rho)+rho*exp(Z(-1))+eps_z;

end;

// Steady state block

initval;
Y=alpha_a*K;
Z=log(1);
C=log(alpha_a*K-delta*K);
K=log((1-beta+beta*delta)/(beta*alpha_a))/(alpha_a-1);

end;
//<Option 2: create m-file with same name as mod file + "_steadystate">

steady;
check;

// Shocks block
shocks;
var eps_z; stderr 0.1;
end;

// Solution block 
stoch_simul(order=1,IRF=40, periods=1000) Y K C Z;



