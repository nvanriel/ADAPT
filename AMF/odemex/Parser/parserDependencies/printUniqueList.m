% Print unique members in comma separated value ingoring the ones found in
% invars.

function l = printUniqueList( llist, invars, idtype )

    llist = unique( llist );
    
    if nargin > 1
        for b = 1 : length( invars )
            a = 1;
            while( a <= length( llist ) )
                if strcmp( llist(a), invars(b) )
                    llist( a ) = [];
                else
                    a = a + 1;
                end
            end
        end
    end
    
    if nargin < 3, idtype = 'realtype'; end

    if ~isempty( llist )
        l = sprintf( '%s %s ', idtype, llist{1} );
    
        for b = 2 : length( llist )
             l = sprintf( '%s, %s %s', l, llist{b} );
        end
    else
        l = '';
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
