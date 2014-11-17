    clear all;    

    mStruct.s.x1 = 1;
    mStruct.s.x2 = 2;
    mStruct.p.k1 = 1;
    mStruct.p.k2 = 2;
    mStruct.p.k3 = 3;
    mStruct.u.u1 = 1;
    mStruct.c.c1 = 1;
    
    %% Custom options 
    odeInput = 'MATLAB_models/mymodel2.m';
    dependencies = { 'MATLAB_models/addtwo.m' };
    
    options = cParserSet( 'blockSize', 5000 );
    convertToC( mStruct, odeInput, dependencies, options );
    compileC( 'mymodel2C' );
    
    time            = [0:.1:10];
    initCond        = [3,5];
    params          = [2,3,4];
    tols            = [ 1e-6 1e-8 10 ];
    input           = 1;
    
    % Stack the parameters and initial condition in a parameter vector
    pars            = [ params, initCond ];
    
    % Compute the sensitivities using the forward sensitivity calculations
    tols            = [ 1e-8 1e-9 10 ];
    tic
    [ t y_odeC, S ]   = mymodel2C( time, initCond, params, input, tols, 1 );   
    toc
    
    % Make a routine that computes the model and concatenates the outputs
    % (since lsqnonlin only uses vector residuals)
    tols   = [ 1e-8 1e-9 10 ];
    resids = @( pars ) ( reshape( mymodel2C( time, pars(4 : 5), ...
                            pars( 1 : 3 ), input, tols ).', ...
                            length( time ) * 2, 1 ) );
    
    % Set the options of the optimiser in such a way that it does not
    % perform any fitting. We are simply exploiting it to calculate a
    % numerical Jacobian w.r.t. the parameters and initial conditions
    tic
    options = optimset( 'MaxIter', 0, 'MaxFunEvals', 0 );
    [x,resnorm,residual,exitflag,output,lambda,jacobian] = ...
                            lsqnonlin( resids, pars, [], [], options );
    toc
    
    % Reshape the Jacobian
    jacobian = reshape( full( jacobian ), length( time ), 10 );
    
    % Compare the two!
    figure;
    subplot( 1, 3, 1 );
    plot( jacobian );
    title( 'Numerical Jacobian' );
    subplot( 1, 3, 2 );
    plot( S.' );
    title( 'Forward sensitivity result' );
    subplot( 1, 3, 3 );
    plot( jacobian - S.' );
    title( 'Difference' );
%
% Joep Vanlier, 2011
%
% Licensing:
%   Copyright (C) 2009-2011 Joep Vanlier. All rights
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
