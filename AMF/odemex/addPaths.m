% List of functions within the toolboxes
%
% Compiling ODE's
%   convertToC( mStruct, odeInput, dependencies, options )
%   compileC( outputName )
%
% Generic Functions
%   nJac( func, pars, dx, subVec )
%
% Monte Carlo Markov Chains
%   [ chain, energy, nAcc, nRej ]   = mcmcCoV( funVec, parameters, methodOpts, numSteps, (lb), (ub), (Aineq), (Bineq), (burnIn) ) 
%   [ CoV, scale ]                  = tuneChain( fun, initPars, CoV, iter, (lb), (ub), (A), (B), (burnIn), (minSteps) )
%
% Profile Likelihoods
%   [ plOut, sse ]                  = PL( func, initPar, param, outer, thresh, loga, opts, minStep, maxStep, minChange, maxChange )

q       = dir;
cdir    = [ pwd '/' ];
for a = 1 : length( q )
    if q(a).isdir == 1
        if ( q(a).isdir ~= '.' ) || ( q(a).isdir ~= '..' )
            addpath( [ cdir, q(a).name ] );
        end
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
