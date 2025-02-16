var y i;
varexo a;

parameters A g c b beta m rhoi rhoy;

A = 10;
g = 0.4;
c = 0.7;
b = 2.5;
beta = 3;
m = 0.7;
rhoi = 5;
rhoy = 7;

model;

y - y(-1) = (1/rhoy)*(-b*i(-1) + g + A + a(-1) - (1-c)*y(-1));
i - i(-1) = (1/rhoi)*(y(-1) - beta*i(-1) - m);

end;

steady;

shocks;

var a;
periods 1:1000;
values -0.05;

end;

perfect_foresight_setup(periods=1000);
perfect_foresight_solver;