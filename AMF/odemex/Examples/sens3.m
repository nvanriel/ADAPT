    
    clear all;
    mStruct.s.x1 = 1;
    mStruct.s.x2 = 2;
    mStruct.p.k1 = 1;
    mStruct.p.k2 = 2;
    mStruct.p.k3 = 3;
    mStruct.u.u1 = 1;
    mStruct.c.c1 = 1;
    
    %% Compile without analytical Jacobian
    odeInput = 'MATLAB_models/mymodel2.m';
    dependencies = { 'MATLAB_models/addtwo.m' };
    
    options = cParserSet( 'blockSize', 5000, 'aJac', 0 );
    convertToC( mStruct, odeInput, dependencies, options );
    compileC( 'mymodel2C' );
    
    %% Compile with analytical Jacobian
    odeInput = 'MATLAB_models/mymodel2.m';
    dependencies = { 'MATLAB_models/addtwo.m' };
    
    options = cParserSet( 'blockSize', 5000, 'aJac', 1 );
    convertToC( mStruct, odeInput, dependencies, options );
    compileC( 'mymodel2D' );
    
    options = odeset( 'RelTol', 1e-6, 'AbsTol', 1e-8 );
    
    time1           = [0:.1:5];
    time2           = [5:.1:10];
    initCond        = [3,5];
    params          = [2,3,4];
    tols            = [ 1e-6 1e-8 10 ];
    input           = 1;
    
    %% Without analytical Jacobian
    % Compute sensitivity in one step
    tic;
    [ t y_odeC, S ]   = mymodel2C( [time1 time2(2:end)], ...
                                    initCond, params, input, tols, 1 );
    t1 = toc;
        
    % Compute sensitivity in two steps
    [ t y_odeC, S1 ]   = mymodel2C( [time1], initCond, params, ...
                                                input, tols, 1 );
                                            
    % Propagate the initial conditions for y and the 
    % sensitivities from the previous simulation
    [ t y_odeC, S2 ]   = mymodel2C( [time2], y_odeC(:, end), params, ...
                                            input, tols, 1, S1(:,end) );
    
    %% With analytical Jacobian
    tic;
    [ t y_odeC, S_2 ]   = mymodel2D( [time1 time2(2:end)], ...
                                    initCond, params, input, tols, 1 );
    t2 = toc;
        
    % Compute sensitivity in two steps
    [ t y_odeC, S1_2 ]   = mymodel2D( [time1], initCond, params, ...
                                                input, tols, 1 );
                                            
    % Propagate the initial conditions for y and the 
    % sensitivities from the previous simulation
    [ t y_odeC, S2_2 ]   = mymodel2D( [time2], y_odeC(:, end), params, ...
                                            input, tols, 1, S1_2(:,end) );    
    
                                        
    figure;
    subplot( 2, 3, 1 );
    plot( S.' );
    title( 'Sensitivities Single Step' );
    subplot( 2, 3, 2 );
    plot( [S1(:,1:end-1) S2].' );
    title( 'Sensitivities Two Step' );
    subplot( 2, 3, 3 );
    plot( S.'-[S1(:,1:end-1) S2].' );
    title( 'Difference' );
    
    subplot( 2, 3, 4 );
    plot( S_2.' );
    title( 'AnalyticalSensitivities Single Step' );
    subplot( 2, 3, 5 );
    plot( [S1_2(:,1:end-1) S2_2].' );
    title( 'AnalyticalSensitivities Two Step' );
    subplot( 2, 3, 6 );
    plot( S_2.'-[S1_2(:,1:end-1) S2_2].' );
    title( 'Difference' ); 
    
    
    figure;
    title( 'Without analytical Jacobian' );
    subplot(1,3,1);
    plot( S.' );
    
    subplot(1,3,2);
    plot( S_2.' );
    title( 'With analytical Jacobian' );
    
    subplot(1,3,3);
    plot( S_2.' - S.' );
    title( 'Difference' );
    
    disp( sprintf( 'Time taken without analytical derivatives %d', t1 ) )
    disp( sprintf( 'Time taken with analytical derivatives %d', t2 ) )
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
