% Function to set options of the parser
%
% Possible options are:
%       solver          Type of solver to use (* is default)
%                       1 dense solver*
%                       2 dense solver with LAPACK/BLAS
%                       3 scaled preconditioned GMRES
%                       4 preconditioned Bi-CGStab solver
%                       5 preconditioned TFQMR iterative 6 solver
%                       10 non-stiff problems 
%
%       blockSize       Number of time steps to allocate each block
%                       when output times are not specified.
%                       Default: 1000
%
%       maxErrFail      Maximum number of times the error criterions may
%                       fail within one timestep (many failures means 
%                       long simulation time).
%                       Default: 15
%
%       maxConvFail     Number of times the convergence of the linear
%                       subproblem may fail during one timestep.
%                       Default: 1000000
%
%       maxStep         Maximum number of time steps allowed
%                       Default: 1000000000
%
%       nonNegative     Will enforce non negativity of the solutions
%                       note that this amounts to reiterating a step
%                       whenever it is even slightly negative
%                       resulting in significant slowdowns
%                       Default: 0 (off)
%
%		fixedRange 		Makes sure that when a dynamic time interval
% 						[ start finish ] is given, the end time actually
% 						corresponds to the specified end time.
% 						Default: 1 (on)
%		
% 		aJac 			Use analytic Jacobian RHS for sensitivity
% 						calculation (experimental!!)
%
%       minStep         minimum stepsize (default = 1e-14)
%
%       maxStepSize     maximum stepsize (default = 1e14)
%
% Written by J. Vanlier
% Contact: j.vanlier@tue.nl

function options = cParserSet( varargin )

inputArgs = { 'debug', 'fJac', 'aJac', 'solver', 'blockSize', 'maxErrFail', 'maxConvFail', 'maxStep', 'nonNegative', 'minStep', 'fixedRange', 'maxStepSize' };
defaultVals = { 0, 0, 0, 1, 1000, 15, 1000000, 1000000000, 0, 1e-14, 1, 1e5 };

start = 1;

if nargin == 0
    options = [];
else
    try
        if isa( varargin{ 1 }, 'char' )
            start = 1;
            options = [];
        else
            if isa( varargin{ 1 }, 'struct' )
                options = varargin{1};
                start = 2;
            else
                disp( 'Argument one is invalid' );
                return;
            end
        end
    catch
    end    
end

if ~isempty( options )
    for a = 1 : length( inputArgs )
        try
            getfield( options, inputArgs{a} );
        catch
            disp( 'Invalid options structure!' );
            return;
        end
    end
else
    for a = 1 : length( defaultVals )
        options = setfield( options, inputArgs{a}, defaultVals{a} );
    end
end

for a = start : 2 : nargin - 1
    try
        found = 0;
        for b = 1 : length( inputArgs )
            if strcmp( varargin{ a }, inputArgs{ b } )
                found = 1;
            end
        end
        if found == 1
            options = setfield( options, varargin{ a }, varargin{ a + 1 } );
        else
            disp( sprintf( 'Invalid option: %s', varargin{ a } ) )
        end
    catch
        disp( sprintf( 'Problem setting options.' ) )
    end
end

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
