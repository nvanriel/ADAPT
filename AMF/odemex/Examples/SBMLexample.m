
if exist( 'Parser' ) ~= 7
	error ( 'Run this one level up from the parser dir' );
end

inDir   = 'SBML_Files';
inFn    = 'HIF_4.xml';
outFn   = 'HIF_4.m';
outDir  = 'tmp';
mkdir( outDir );

[ mStruct, p, x0, u0 ]  =   SBMLtoM( inDir, inFn, outDir, outFn );

odeInput = [ outDir '/' outFn ];
addPath(  [ outDir '/' ] );

a = dir( [ outDir ] );
c = 1;
for b = 1 : length( a )
    if a(b).isdir == 0
        if strcmp( a(b).name, outFn ) == 0
            dependencies{ c } = [ outDir '/' a(b).name ];
        end
    end
end
    
options = cParserSet( 'blockSize', 5000 );
convertToC_IDA( mStruct, odeInput, dependencies, options );
convertToC( mStruct, odeInput, dependencies, options );

compileC( 'HIF_CV', 0 );
compileC( 'HIF_IDA', 1 );


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
