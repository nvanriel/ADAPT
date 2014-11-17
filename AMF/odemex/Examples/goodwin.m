%% Model 1
mStruct.p.a1  = 1;
mStruct.p.a2  = 2;
mStruct.p.alf = 3;

N = 25;
for k = 1 : N
    eval( sprintf( 'mStruct.p.k%d = %d;', k, k+3 ) );
end

for k = 1 : N
    eval( sprintf ( 'mStruct.s.x%d = %d;', k, k ) );
end


%% Compile with analytical Jacobian
odeInput = 'MATLAB_models/goodwinN.m';
    
options = cParserSet( 'blockSize', 5000, 'fJac', 0 );
convertToC( mStruct, odeInput, {}, options );
compileC( 'goodwin5' );

options = cParserSet( 'blockSize', 5000, 'fJac', 1 );
convertToC( mStruct, odeInput, {}, options );
compileC( 'goodwin5_jac' );

%par         = [0.6625    0.5233    0.2599    0.9620    0.5402    0.0303    0.6963  0.9620    0.5402    0.0303    0.6963];
rand( 'state', 5805 );
par         = rand( N+3, 1 );
par(1:3)    = [ 0.6625 0.5233 0.2599 ];
tols        = [ 1e-10, 1e-12, 10 ];
x0          = zeros( N, 1 );
t           = [ 0 : 0.1 : 2000 ];


%% simulation
disp( 'Without Jacobian' );
tic;
for q = 1 : 100
    [t,g1]       = goodwin5( t, x0, par, [], tols );
end
toc;

disp( 'With Jacobian' );
tic;
for q = 1 : 100
    [t,g2]       = goodwin5_jac( t, x0, par, [], tols );
end
toc;

subplot(3,1,1);
plot( t, g1 );
title( 'Without jacobian' );

subplot(3,1,2);
plot( t, g2 );
title( 'With jacobian' );

subplot(3,1,3);
plot( t, g2 - g1 );
title( 'Difference' );

clear goodwin5
clear goodwin5_jac