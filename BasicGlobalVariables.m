% BasicGlobalVariables.m

global X Y Z
X = 1;
Y = 2;
Z = 3;

%%%% Walk Control Definitions %%%%%
global SingleSupport DoubleSupport RIGHT LEFT G deg2rad rad2deg
SingleSupport = 1;
DoubleSupport = 2;

RIGHT = 1;
LEFT  = 2;

G = 9.8;       % m/s^2

deg2rad = pi/180;
rad2deg = 180/pi;

global ToDeg ToRad
ToDeg = rad2deg;
ToRad = deg2rad;


global FreeContact ToeContact HeelContact
FreeContact = 0;
ToeContact  = 1;
HeelContact = 2;
