    clear all
    
    mStruct.s.x1        = 1;
    mStruct.s.x2        = 2;
    mStruct.p.k1        = 1;
    mStruct.u.u1        = 1;
    
    % Note that you need to allocate elements for both time as well as the
    % actual data.
    nelem  		= 6;
    mStruct.u.time1     = 2:2+6-1;
    mStruct.u.linear1   = 2+6:2+2*6-1;
    
    mStruct.u.time2     = 14:14+6-1;
    mStruct.u.linear2   = 14+6:14+2*6-1;
    
    %% Custom options 
    odeInput = 'MATLAB_models/mymodel3.m';
    dependencies = {};
    
    options = cParserSet( 'blockSize', 5000 );
    convertToC( mStruct, odeInput, dependencies, options );
    compileC( 'mymodel3C' );
    
    options = odeset( 'RelTol', 1e-6, 'AbsTol', 1e-8 );
    
    %[t y_MATLAB] = ode15s( @mymodel2, [0:.001:10], [3,5], options, ...
    %                                    [2, 3, 4], [1], mStruct );

    % Time points for the driving inputs
    t = 0:2:10;
    
    % Values at the time points for the driving inputs
    u1 = [4,5,6,7,6,9];
    u2 = [1,2,3,4,8,9];
    
    % Time points for the simulation
    dt      = .01;
    tend    = 15;
    tPoints = [0:dt:tend];
    x0      = [3,5];

    % Inputs
    inputs  = [1, t, u1, t, u2 ];
    
    [ tz y_odeC ]   = mymodel3C( tPoints, x0, [1], inputs, [ 1e-6 1e-8 10 ] );   
    
    % Manually integrate    
    u1S = interp1( t, u1, tPoints, 'linear' );
    u2S = interp1( t, u2, tPoints, 'linear' );
    for z = 1 : length( tPoints )
        u1I(z) = dt * trapz( u1S(1:z) ) + x0(1);
        u2I(z) = dt * trapz( u2S(1:z) ) + x0(2);
    end
    
    plot( tz, y_odeC.' );
    hold on;
    plot( tPoints, u1I, 'b.-' );
    plot( tPoints, u2I, 'g.-' );
    
    legend( 'Integrator State 1', 'Integrator State 2', 'Manual State 1', 'Manual State 2' );
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
