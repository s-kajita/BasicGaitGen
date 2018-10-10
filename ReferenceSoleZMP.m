function [zmpx_m,zmpy_m,soleR_m,soleL_m,phase_m,sup_m,steps_m]  = ReferenceSoleZMP(time,Tsup,Tdbl,StepL,StepW,Nsteps,Zup)
% SoleReferenceZMP  
%   make sole reference and ZMP trajectories
global RIGHT LEFT SingleSupport DoubleSupport

tsize = length(time);
Dtime = time(2)-time(1);

%---- initial state ---------
sup   = RIGHT;
swg   = LEFT;
phase = DoubleSupport;
phase_time = 0.0;

%Zup = 0.05;
%Zup = 0.0;

steps  = 0;
fsteps = 0;

yref = [-StepW StepW];

x  = [0 0];       % RIGHT LEFT
y  = yref;        % RIGHT LEFT
z  = [0 0];
vx = [0 0];
vy = [0 0];
vz = [0 0];

xf   = 0;
yf   = y(sup);
zmpxf = xf;
zmpyf = yf;

zmpx  = 0;
zmpy  = 0;
zmpvx = 0;
zmpvy = 0;

tf0      = 2.0*Tsup;
tf1      = tf0 + Tdbl;

SS_start = false;
stepping = true;

for n = 1:tsize    
    switch phase
        case DoubleSupport
            if stepping && time(n) > tf1
                phase    = SingleSupport;
                SS_start = true;
            end
            if time(n) > tf0
                [zmpvx,zmpx] = DynamicPlan2(time(n)-tf1,zmpvx,zmpx, 0, zmpxf, Dtime);
                [zmpvy,zmpy] = DynamicPlan2(time(n)-tf1,zmpvy,zmpy, 0, zmpyf, Dtime);                
            end
            
        case SingleSupport
            if SS_start
                SS_start = false;
                
                tf0 = time(n);
                tf1 = time(n) + Tsup/2;
                tf2 = time(n) + Tsup;
                
                if steps < Nsteps-2
                    xf = x(sup) + StepL;
                end
                yf = yref(swg);
            end
                        
            %------------ Swing leg motion generation
            [vx(swg),x(swg)] = ...
                DynamicPlan2(time(n)-tf2,vx(swg),x(swg), 0,xf,Dtime);
            [vy(swg),y(swg)] = ...
                DynamicPlan2(time(n)-tf2,vy(swg),y(swg), 0,yf,Dtime);
            
            if time(n) < tf1
                [vz(swg),z(swg)] = ...
                    DynamicPlan2(time(n)-tf1,vz(swg),z(swg), 0.0, Zup, Dtime);
            elseif time(n) < tf2
                [vz(swg),z(swg)] = ...
                    DynamicPlan2(time(n)-tf2,vz(swg),z(swg), 0.0, 0.0, Dtime);
            else
                phase = DoubleSupport;
                tf0 = time(n);
                tf1 = tf0 + Tdbl;
                
                steps = steps + 1;
                [sup,swg] = swap(sup,swg);
                if steps > Nsteps-2
                    stepping = false;
                    zmpxf = 0.5*(x(sup)+x(swg));
                    zmpyf = 0.5*(y(sup)+y(swg));
                else
                    zmpxf = xf;
                    zmpyf = yf;
                end
            end
    end            
                
    if n==1
        % ----- output variables ----------
        zmpx_m  = zeros(tsize,1);
        zmpy_m  = zeros(tsize,1);
        soleR_m = zeros(tsize,3);  % [X Y Z]
        soleL_m = zeros(tsize,3);  % [X Y Z]
        phase_m = zeros(tsize,1);
        sup_m   = zeros(tsize,1);
        steps_m = zeros(tsize,1);
    end
    
    zmpx_m(n)    = zmpx;
    zmpy_m(n)    = zmpy;
    soleR_m(n,:) = [x(RIGHT) y(RIGHT) z(RIGHT)];
    soleL_m(n,:) = [x(LEFT)  y(LEFT)  z(LEFT) ];
    phase_m(n)   = phase;
    sup_m(n)     = sup;
    steps_m(n)   = steps;
end
