function s = replaceWithIndex( list, allpoints )

    s = '';
    indices = [];
    for a = 1 : length( list )
        for b = 1 : length( allpoints )
            if ( list(a) == allpoints(b) )
                indices(a) = b;
            end
        end
    end
    if ~isempty( indices )
        s = sprintf( '%d', indices(1) );
        for a = 2 : length( indices )
            s = sprintf( '%s, %d', s, indices(a) );
        end
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
