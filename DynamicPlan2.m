function [v2,x2,a2]=DynamicPlan2(t,v,x,vf,xf,dt)
% Dynamics Planning for Trajectory
% performance index considering velocitry
%    x(t)=a.exp(t)+b.exp(-t)+c.t+d
% '98 May 9  s.k MEL

m = 1.0;

if t >= 0.0
    v2 = vf;
    x2 = x+vf*dt;
    a2 = 0;
elseif t^4 < eps
    v2 = v;
    x2 = x;
    a2 = 0; 
else    %  status for the next step
    Exp =  exp(t/m);
    Expm = 1/Exp;
    MT = [Exp        Expm		t   1;
          Exp/m     -Expm/m	1   0;
              1		1		0   1;
              1/m	-1/m		1   0];
    XX = [x; v; xf; vf];         
    CC = MT \ XX;
     
    t2 = t+dt;
    Exp2  = exp(t2/m);
    Expm2 = 1/Exp2;
    x2 = CC(1)*Exp2     +CC(2)*Expm2    +CC(3)*t2+CC(4);
    v2 = CC(1)/m*Exp2   -CC(2)/m*Expm2  +CC(3);
    a2 = CC(1)/m^2*Exp2 +CC(2)/m^2*Expm2;
 end
