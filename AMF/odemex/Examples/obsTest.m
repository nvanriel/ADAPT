clear all;
mStruct.s.x1            = 1;
mStruct.s.x2            = 2;
mStruct.p.k1            = 1;
mStruct.p.k2            = 2;
mStruct.p.k3            = 3;
mStruct.u.u1            = 1;
mStruct.c.c1            = 1;

mStruct.o.sigma1        = 1;
mStruct.o.sigma2        = 2;
mStruct.i.x2_0          = mStruct.s.x2;

%% Compile with analytical Jacobian
odeInput = 'MATLAB_models/mymodel2.m';
dependencies = { 'MATLAB_models/addtwo.m' };

options = cParserSet( 'blockSize', 5000, 'aJac', 1 );
convertToC( mStruct, odeInput, dependencies, options );
compileC( 'mymodel2D' );

%% Set up the observer functions (3 observers)
obs{1} = 'k1*u1*x1([0:.1:1]) * (1+sigma1)';
obs{2} = 'k2*(x1([0,1,2,3,4]) + x2([0,1,2,3,4]) - data({1,2,3,4,5})) / (1+sigma2)';
obs{3} = 'k3*x2([0:.1:5])./x1([0:.1:5])/k2';

% All the parameters (3 model parameters, one initial condition and two
% observer parameters)
params  = [ 2 3 4 5 1 1 ];
data    = [4,3,7,4,5];
input   = 1;
tols    = [ 1e-6 1e-8 10 ];

% Create and compile the observerfunctions with Jacobian
[ timePts, parIndices, obsIndices, icIndices ] = observerFunctions( 'test', obs, mStruct, 1 );

% Make a quick wrapper which calls the model and observation function
disp( 'Finite Differencing' );
tic
for a = 1 : 1000
    func = @(pars)test( mymodel2D( timePts, [3 pars(icIndices(mStruct.i.x2_0))], pars(parIndices), input, tols ), pars, data, input );
    jac = nJac( func, params, 1e-8 );
end
toc

% Use the observation function on the model simulation and actually
% propagate sensitivities
disp( 'Sensitivity Equations' );
tic
for a = 1 : 1000
    [ t y_odeC, S1 ] = mymodel2D( timePts, [3 params(icIndices(mStruct.i.x2_0))], params(parIndices), input, tols, 1 );
    [ observ, sens ] = test( y_odeC, params, data, input, S1 );
end
toc

close all;
subplot(3,1,1);
plot( sens )
title( 'Sensitivity Equations' );
subplot(3,1,2);
plot( jac );
title( 'Finite Differences' );
subplot(3,1,3);
plot( sens-jac );
title( 'Difference' );

%
% Joep Vanlier, 2012
%
% Licensing:
%   Copyright (C) 2009-2012 Joep Vanlier. All rights
%   reserved.
%
%   Contact:joep.vanlier@gmail.com
%
%   This file is part of the puaMAT.
%   
%   puaMAT is free software: you can redistribute it 
%   and/or modify it under the terms of the GNU General 
%   Public License as published by the Free Software 
%   Foundation, either version 3 of the License, or (at 
%   your option) any later version.
%
%   puaMAT is distributed in the hope that it will be
%   useful, but WITHOUT ANY WARRANTY; without even the 
%   implied warranty of MERCHANTABILITY or FITNESS FOR A 
%   PARTICULAR PURPOSE.  See the GNU General Public 
%   License for more details.
%   
%   You should have received a copy of the GNU General
%   Public License along with puaMAT.  If not, see
%   http://www.gnu.org/licenses/
%
