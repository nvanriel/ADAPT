clear all;

%% Set up the mstruct for a 25 state goodwin oscillator
mStruct.p.a1 = 1;
mStruct.p.a2 = 2;
mStruct.p.alf = 3;

N = 25;
for k = 1 : N
    eval( sprintf( 'mStruct.p.k%d = %d;', k, k+3 ) );
end

for k = 1 : N
    eval( sprintf ( 'mStruct.s.x%d = %d;', k, k ) );
end

mStruct.o.sigma1 = 1;

%% Compile with and without analytical Jacobian
odeInput = 'MATLAB_models/goodwinN.m';
dependencies = { };

options = cParserSet( 'blockSize', 5000, 'aJac', 0, 'fJac', 1, 'maxStepSize', 0.1, 'debug', 1 );
convertToC( mStruct, odeInput, dependencies, options );
compileC( 'goodwin' );

options = cParserSet( 'blockSize', 5000, 'aJac', 1, 'fJac', 1, 'maxStepSize', 0.1, 'debug', 1 );
convertToC( mStruct, odeInput, dependencies, options );
compileC( 'goodwin_jac' );

% Simulate the true model
tols    = [ 1e-4 1e-4 10 ];
t       = [ 0 : 1 : 40 ];
trueSig = 2;
parTrue = rand( 1, N+3 );
parTrue(1:3) = [ 0.6625 0.5233 0.2599 ];
lb      = zeros( length( parTrue ) + 1, 1 );
x0      = zeros( 25, 1 );
data    = goodwin( t, x0, parTrue, [], tols );
data    = data(1,:) + trueSig * randn( 1, length(t) );

%% Set up the observer functions (3 observers)
obs{1} = '100*(x1([0:1:40])-data({1:41}))/(sigma1)';
obs{2} = 'sqrt(41*log(sigma1))';

% Create and compile the observerfunctions with Jacobian (last flag)
[ timePts, parIndices, obsIndices, icIndices ] = observerFunctions( 'goodwinObs', obs, mStruct, 1 );

% Do a Monte Carlo sampling of random parameter vectors
N_samples   = 100;
for a = 1 : N_samples
    par(a,:)      = [parTrue trueSig*100] .* (1+3*randn( 1, length(parTrue) + 1 ));
end

%% Set up the simulation functions
simJac = @(pars)goodwin_jac( t, x0, pars(parIndices), [], [ 1e-5 1e-5 30 ], 1 );
simNonJac = @(pars)goodwin( t, x0, pars(parIndices), [], [ 1e-8 1e-8 30 ] );

%% Set up the observation functions
obsJac = @(sims,pars,J)goodwinObs( sims, pars, data, [], J );
obsNonJac = @(sims,pars)goodwinObs( sims, pars, data, [] );

%% Link the two
lsqFunJac = @(pars)useObserver( obsJac, simJac, pars );
lsqFunNonJac = @(pars)useObserver( obsNonJac, simNonJac, pars );

%% Do N_samples fits with Jacobian based on Sensitivity Equations
disp( 'With Jacobian' );
tic;
options = optimset('Jacobian','on','TolFun',1e-6,'TolX',1e-6,'Display', 'off' );
for a = 1 : N_samples
    disp( sprintf( '%d/%d', a, N_samples ) );
    try
        [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN1] = lsqnonlin(lsqFunJac,par(a,:),lb,[],options);
        with(a) = RESNORM;
    catch
        with(a) = inf;
    end
end
withTime = toc;

%% Do N_samples fits with Jacobian based on Finite Differences
disp( 'Without Jacobian' );
tic;
options = optimset('Jacobian','off','TolFun',1e-6,'TolX',1e-6,'Display', 'off' );
for a = 1 : N_samples
    disp( sprintf( '%d/%d', a, N_samples ) );
    try
        [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN2] = lsqnonlin(lsqFunNonJac,par(a,:),lb,[],options);
        without(a) = RESNORM;
    catch
        without(a) = inf;
    end
end
withoutTime = toc;

%% Plot some stuff
plot( sort( with ), 'k' ); hold on;
plot( sort( without ), 'r' );
ylabel( 'Final sum of squared error' );
xlabel( 'Sorted index' );
legend( 'Sensitivity equations', 'Finite differences' );
title( sprintf( 'T_{SE} = %f s, T_{FD} = %f s', withTime, withoutTime ) );


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
