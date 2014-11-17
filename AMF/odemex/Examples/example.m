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
    
    addpath( 'MATLAB_models' );
    [t y_MATLAB] = ode15s( @mymodel2, [0:.001:10], [3,5], options, ...
                                        [2, 3, 4], [1], mStruct );

    
    [ t y_odeC ]   = mymodel2C( [0:.001:10], [3,5], [2, 3, 4], ...
                                            [1], [ 1e-6 1e-8 10 ] );   
                                        
                                        
    plot( t, ( y_MATLAB - y_odeC.' ) ./ y_MATLAB );
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
