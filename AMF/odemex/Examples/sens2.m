    
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
    
    options = odeset( 'RelTol', 1e-6, 'AbsTol', 1e-8 );
    
    time1           = [0:.1:5];
    time2           = [5:.1:10];
    initCond        = [3,5];
    params          = [2,3,4];
    tols            = [ 1e-6 1e-8 10 ];
    input           = 1;
    
    % Compute sensitivity in one step
    [ t y_odeC, S ]   = mymodel2C( [time1 time2(2:end)], ...
                                    initCond, params, input, tols, 1 );
        
    % Compute sensitivity in two steps
    [ t y_odeC, S1 ]   = mymodel2C( [time1], initCond, params, ...
                                                input, tols, 1 );
    % Propagate the initial conditions for y and the 
    % sensitivities from the previous simulation
    [ t y_odeC, S2 ]   = mymodel2C( [time2], y_odeC(:, end), params, ...
                                            input, tols, 1, S1(:,end) );
    
    figure;
    subplot( 1, 3, 1 );
    plot( S.' );
    title( 'Sensitivities Single Step' );
    subplot( 1, 3, 2 );
    plot( [S1(:,1:end-1) S2].' );
    title( 'Sensitivities Two Step' );
    subplot( 1, 3, 3 );
    plot( S.'-[S1(:,1:end-1) S2].' );
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
