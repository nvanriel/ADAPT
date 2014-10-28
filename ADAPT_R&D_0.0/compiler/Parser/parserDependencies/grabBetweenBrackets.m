function [ between, rest ] = grabBetweenBrackets( inputString )

brackets = 1;
ptr = 1;
between = '';

while( ~strcmp( inputString( ptr ), '(' ) )
    ptr = ptr + 1;
end

ptr = ptr + 1;
startPtr = ptr;

while ( ( brackets > 0 ) & ( ptr <= length( inputString ) ) )
    if strcmp( inputString( ptr ), '(' )
        brackets = brackets + 1;
    end
    if strcmp( inputString( ptr ), ')' )
        brackets = brackets - 1;
    end
    ptr = ptr + 1;
end

if ( brackets > 0 )
    disp( sprintf( 'WARNING: No closing bracket detected.\nRelevant code: %s!\n', inputString ) );
end

between = inputString( startPtr : ptr - 2 );
rest = inputString( ptr : end );


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
