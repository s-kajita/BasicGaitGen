% tridiagonal_demo.m

close all
clear

BasicGlobalVariables;

Zh    = 0.8;
Dtime = 0.005;
EndTime = 6.0;

%------------- Generate target ZMP
StepL = 0.5;  % m
StepW = 0.1;
Nsteps = 5;
Tsup  = 0.7;
Tdbl  = 0.05;   % s
Zup   = 0.05;

Dtravel = max(Nsteps-2,0)*StepL; 

time = [0:Dtime:EndTime]';
tsize = length(time);

[zmpx,zmpy,soleR,soleL,phase,sup,steps]  = ReferenceSoleZMP(time,Tsup,Tdbl,StepL,StepW,Nsteps,Zup);

%------------------

N = length(time);
M = zeros(N,N);

Zh    = 0.9;
G     = 9.8;
Dtime = 0.005;

a = -(Zh/G)/Dtime^2;
b = 1-2*a;
c = a;

for n=1:N
    if n == 1
        M(1,1) = a+b;
        M(1,2) = c;
    elseif n < N
        M(n,n-1) = a;
        M(n,n)   = b;
        M(n,n+1) = c;
    else
        M(N,N-1) = a;
        M(N,N)   = b+c;
    end
end

figure
subplot(211)
plot(time,zmpx,'r')
legend('zmpx')
ylabel('[m]')
xlabel(' time [s]')

subplot(212)
plot(time,zmpy,'r')
legend('zmpy')
ylabel('[m]')
xlabel(' time [s]')

pause
figure; imagesc(M)
title('matrix M')

pause 
figure; imagesc(M^-1)
title('matrix M^-1')

pause
figure
plot(time,zmpx,'r',time,M^-1*zmpx,'k')
legend('ZMPx','CoMx')
ylabel('[m]')
xlabel('time [s]')

pause
plot(time,zmpy,'r',time,M^-1*zmpy,'k')
legend('ZMPy','CoMy')
ylabel('[m]')
xlabel('time [s]')
