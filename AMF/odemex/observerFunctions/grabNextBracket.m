function [ before, values, remainder ] = grabNextBracket( l )

    before = '';
    values = [];
    remainder = '';

    pos = 1;
    
    while ( pos < length( l ) & ( l(pos) ~= '[' ) )
        pos = pos + 1;
    end
    
    if l(pos) == '['
    
        before = l( 1 : pos );
        pos1 = pos;
        depth = 1;

        while ( ( pos <= length( l ) ) & ( depth > 0 ) )
            if l(pos) == ']'
                depth = depth - 1;
            end
            pos = pos + 1;
        end
        values = eval( l( pos1 : pos - 1 ) );
        
        remainder = l( pos-1:end );
    else
        before = l;
    end
    
    
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
