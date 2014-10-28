function [ outVars, inVars, funcName ] = analyseFunctionHeader( string )

outVars = {};
inVars = {};

% remove function handle
string = strrep( string, 'function', '' );

[ pre post ] = strtok( string, '=' );

funcName = fliplr( strtok( fliplr(strtok( post, '(' ) ), ' =' ) );

[ tok rem ] = strtok( pre, '[], ' );
if isempty( tok )
    disp( 'WARNING: No output variable when parsing function' );
end
while ( ~isempty( rem ) | ~isempty( tok ) )
    outVars = { outVars{:}, tok };
    [ tok rem ] = strtok( rem, '[], ' );
end

post = grabBetweenBrackets( post );
[ tok rem ] = strtok( post, '[], ' );

if isempty( tok )
    disp( 'WARNING: No input variable when parsing function' );
end
while ( ~isempty( rem ) | ~isempty( tok ) )
    inVars = { inVars{:}, tok };
    [ tok rem ] = strtok( rem, '[], ' );
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
