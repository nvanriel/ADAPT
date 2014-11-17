function dx = goodwinN(t,x,p,u,modelStruct)

% Parameters:
a1  = p(1);
a2  = p(2);
alf = p(3);

rho     = 2;
order   = 24;

dx( modelStruct.s.x1 )      = ( a1 / ( 1 + a2 * intPow(x(24),rho) ) ) - alf * x( modelStruct.s.x1 );

for k1 = 1 : order
    dx( modelStruct.s.x1 + k1 ) = p( modelStruct.p.k1 + k1 ) * x( modelStruct.s.x1 + k1 - 1 ) - alf * x( modelStruct.s.x1 + k1 );
end