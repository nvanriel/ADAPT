    clear all
    
    mStruct.s.x1        = 1;
    mStruct.s.x2        = 2;
    mStruct.p.k1        = 1;
        
    %% Custom options 
    odeInput = 'MATLAB_models/mymodel4.m';
    dependencies = {};
    
    options = cParserSet( 'blockSize', 5000 );
    convertToC( mStruct, odeInput, dependencies, options );
    compileC( 'mymodel4C' );
    
    options = odeset( 'RelTol', 1e-6, 'AbsTol', 1e-8 );
    
    % Time points for the simulation
    dt      = .01;
    tend    = 15;
    tPoints = [0:dt:tend];
    x0      = [3,5];

    [ tz y_odeC ]   = mymodel4C( tPoints, x0, [1], [], [ 1e-6 1e-8 10 ] );   
       
    plot( tz, y_odeC.' );
    
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
