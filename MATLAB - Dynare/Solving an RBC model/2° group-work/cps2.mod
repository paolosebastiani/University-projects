
//AMACRO, 2024 - Problem set 2

//Variables block 
var c k y z;
varexo eps;

//Parameters block
parameters rho beta alf del sig;


alf= 0.3;
beta=0.99;
del=0.025;
sig=3;
rho=0.9;
sig_z=0.1;



//Model block
model;
exp(y)=exp(z)*exp(k(-1))^(alf);
exp(c)^(-sig)=beta*exp(c(+1))^(-sig)*(alf*exp(z(+1))*exp(k)^(alf-1)+(1-del));
exp(c)+exp(k)=exp(z)*exp(k(-1))^(alf)+(1-del)*exp(k(-1));
exp(z)=(1-rho)+rho*exp(z(-1))+eps;

end;

// Steady state block

initval;
y=alf*k;
z=log(1);
c=log((alf*k)-(del*k));
k=log(((1-beta+beta*del)/(beta*alf))/(alf-1));

end;
//<Option 2: create m-file with same name as mod file + "_steadystate">

steady;
check;

// Shocks block
shocks;
var eps; 
STDERR sig_z;
end;

// Solution block 
stoch_simul(order=1,IRF=1000, periods=1000) y k c z ;