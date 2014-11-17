function dx = goodwin5(t,x,p,u,modelStruct)

% Parameters:
oa1 = p(1);
oa2 = p(2);
alf = p(3);

k1  = p(4);
k2  = p(5);
k3  = p(6);
k4  = p(7);

rho = 10;

x1   = x( modelStruct.s.x1 );
x2   = x( modelStruct.s.x2 );
x3   = x( modelStruct.s.x3 );
x4   = x( modelStruct.s.x4 );
x5   = x( modelStruct.s.x5 );

dx( modelStruct.s.x1 )      = ( oa1 / ( 1 + oa2 * intPow(x5,rho) ) ) - alf * x1;
dx( modelStruct.s.x2 )      = k1 * x1 - alf * x2;
dx( modelStruct.s.x3 )      = k2 * x2 - alf * x3;
dx( modelStruct.s.x4 )      = k3 * x3 - alf * x4;
dx( modelStruct.s.x5 )      = k4 * x4 - alf * x5;

