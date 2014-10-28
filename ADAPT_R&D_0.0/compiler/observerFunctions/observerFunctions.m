function [ timePts, parIndices, obsIndices, icIndices ] = observerFunctions( obsName, obs, mStruct, cjac )

observPath = [ fileparts( mfilename( 'fullpath' ) ) '/' ];

nStates     = max( structIndices( mStruct.s ) );
nPars       = max( structIndices( mStruct.p ) );
try
    nInput  = max( structIndices( mStruct.u ) );
catch
    nInput  = 0 ;
end
parIndices  = 1 : nPars;

allNames = []; types = [];
try allNames = [ allNames ; fieldnames( mStruct.c ); ]; types = [ types ; ones( length( fieldnames( mStruct.c ) ), 1 ) ]; catch; end;
try allNames = [ allNames ; fieldnames( mStruct.p ); ]; types = [ types ; 2*ones( length( fieldnames( mStruct.p ) ), 1 ) ]; catch; end;
try allNames = [ allNames ; fieldnames( mStruct.s ); ]; types = [ types ; 3*ones( length( fieldnames( mStruct.s ) ), 1 ) ]; catch; end;
try allNames = [ allNames ; fieldnames( mStruct.i ); ]; types = [ types ; 4*ones( length( fieldnames( mStruct.i ) ), 1 ) ]; catch; end;
try allNames = [ allNames ; fieldnames( mStruct.o ); ]; types = [ types ; 5*ones( length( fieldnames( mStruct.o ) ), 1 ) ]; catch; end;
try allNames = [ allNames ; fieldnames( mStruct.u ); ]; types = [ types ; 6*ones( length( fieldnames( mStruct.u ) ), 1 ) ]; catch; end;

try
    nObsPars    = max( structIndices( mStruct.o ) );
    obsIndices  = [ 1 : nObsPars ] + nPars;
catch
    nObsPars    = 0;
    obsIndices  = [];
end

icIndices           = zeros( nStates, 1 );
try
    icPars      = structIndices( mStruct.i );
    nIcPars     = length( icPars );
    
    icIndices( icPars ) = [1:nIcPars]+nObsPars+nPars;
catch
    nIcPars     = 0;
end

% Grab all the time points that need to be simulated for the objective
% function
disp( 'Fetching timepoints' );
timePts = [];
for a = 1 : length( obs )
    [ before, values, remainder ] = grabNextBracket( obs{a} );
    timePts = [timePts, values];
    while length( remainder ) > 1
        [ before, values, remainder ] = grabNextBracket( remainder );
        timePts = [timePts, values];
    end
end
timePts = unique( timePts );

% If the zeroth timepoint isn't in the list, add it, because otherwise the
% simulation will have problems
if max(timePts==0) ~= 1
    timePts = [0 timePts];
end
nTime = length(timePts);

disp( 'Replacing timepoints with their indices' );
% Replace the time points by their indices
for a = 1 : length( obs )
    [ before, values, remainder ] = grabNextBracket( obs{a} );
    obsB{a} = [ before replaceWithIndex( values, timePts ) ];
    while length( remainder ) > 1
        [ before, values, remainder ] = grabNextBracket( remainder );
        obsB{a} = [ obsB{a} before replaceWithIndex( values, timePts ) ];
    end
    obsB{a} = [ obsB{a} remainder ];
end

% Grab all the data points
disp( 'Fetching datapoints' );
dataPts = [];
for a = 1 : length( obs )
    [ before, values, remainder ] = grabNextDataBracket( obsB{a} );
    obsB{a} = [ before printAsString( values ) ];
    dataPts = [dataPts, values];
    while length( remainder ) > 1
        [ before, values, remainder ] = grabNextDataBracket( remainder );
        obsB{a} = [ obsB{a} before printAsString( values ) ];
        dataPts = [dataPts, values];
    end
end
obsB{a} = [ obsB{a} remainder ];
dataPts = unique( dataPts );
nData = length( dataPts );

disp( 'Generating syms for the datapoints' );
for it1 = 1 : length( dataPts )
    data(it1) = sym( sprintf( 'data_%d', it1 ) );
end



% Generate all required state syms
disp( 'Generating syms for the states' );

fields = fieldnames( mStruct.s );
for it1 = 1 : length( fields )
    for it2 = 1 : length( timePts )
        syms( sprintf( 's%d_%d', getfield( mStruct.s, fields{it1} ), it2 ) );
        eval( sprintf( 's%d(%d) = s%d_%d;', getfield( mStruct.s, fields{it1} ), it2, getfield( mStruct.s, fields{it1} ), it2 ) );
    end
end

% Process the model parameters
disp( 'Generating syms for the model parameters' );
names = fieldnames( mStruct.p );
for it2 = 1 : length( names )
	parNo = getfield( mStruct.p, names{it2});
	p(parNo) = sym( sprintf( 'p%d', parNo ) );
end

% Process the observable parameters
disp( 'Generating syms for the observational parameters' );
try
    names = fieldnames( mStruct.o );
    for it2 = 1 : length( names )
        parNo = getfield( mStruct.o, names{it2} );
        eval( sprintf( 'syms o%d;', parNo ) );
        eval( sprintf( 'o(%d) = o%d;', parNo, parNo ) );
    end
catch
end

% Process the initial condition parameters
disp( 'Generating syms for the initial condition parameters' );
try
    names = fieldnames( mStruct.i );
    for it2 = 1 : length( names )
        parNo = getfield( mStruct.i, names{it2} );
        eval( sprintf( 'syms i%d;', parNo ) );
        eval( sprintf( 'i(%d) = i%d;', parNo, parNo ) );
    end
catch
end

% Process the inputs
disp( 'Generating syms for the inputs' );
try
    names = fieldnames( mStruct.u );
    for it2 = 1 : length( names )
        parNo = getfield( mStruct.u, names{it2} );
        eval( sprintf( 'syms u%d;', parNo ) );
        eval( sprintf( 'u(%d) = u%d;', parNo, parNo ) );
    end
catch
end

% Replace identifiers by their respective indices
disp( 'Parsing the objective function cell array' );
expressionTokens = '&()[]/*+-^@ %<>,;={}|';
for c = 1 : length( obs )
    output = '';
    
    remain = obsB{c};
    while length( remain ) > 0
        [ token, remain, tokensLost ] = strtok2( remain, expressionTokens );
    
        for q = 1 : length( allNames )
            if strcmp( token, allNames(q) ) == 1
                switch types( q )
                    case 1
                        token = num2str( getfield( mStruct.c, allNames{q} ) );
                    case 2
                        token = sprintf( 'p(%d)', getfield( mStruct.p, allNames{q} ) );
                    case 3
                        token = sprintf( 's%d', getfield( mStruct.s, allNames{q} ) );
                    case 4
                        token = sprintf( 'i(%d)', getfield( mStruct.i, allNames{q} ) );
                    case 5
                        token = sprintf( 'o(%d)', getfield( mStruct.o, allNames{q} ) );
                    case 6
                        token = sprintf( 'u(%d)', getfield( mStruct.u, allNames{q} ) );
                end
            end
        end
        output = [ output tokensLost token ];
    end
    obsB{c} = output;
end

% Construct objective function
obj = [];
for a = 1 : length( obsB );
    try
        obj = [ obj, eval( obsB{a} ) ];
    catch ME
        a
        obsB{a}
        disp( '>>> ERROR: Undeclared variable in objective function(s)' );
        rethrow(ME)
    end
end

c_code      = ccode( obj );
c_code      = strrep( c_code, 'obj[0]', 'obs' );
c_code      = regexprep( c_code, 's(\d+)_(\d+)',  's[($2-1)*N_STATES+($1-1)]' );
c_code      = regexprep( c_code, 'p(\d+)',       'p[$1-1]' );
c_code      = regexprep( c_code, 'u(\d+)',       'u[$1-1]' );
c_code      = regexprep( c_code, 'o(\d+)',       'p[N_PARS+$1-1]' );
c_code      = regexprep( c_code, 'i(\d+)',       'p[N_PARS+N_OBSPARS+$1-1]' );
c_code      = regexprep( c_code, 'data_(\d+)',   'd[$1-1]' );

% Set up the header file
nObs        = length( obj );
nStates     = length( fieldnames( mStruct.s ) );
nPars       = length( fieldnames( mStruct.p ) );
nObsPars    = length( fieldnames( mStruct.o ) );

disp( 'Writing C file for the objective function' )
fid         = fopen( [observPath 'ccode/objfn.c'], 'w' );
fprintf( fid, '#include "objfn.h"\n\n\nvoid objectiveFn(double *obs, double *s, double *p, double *d, double *u ) {\n%s\n}\n', c_code );
fid         = fclose( fid );

fid = fopen( [observPath 'ccode/objfn.h'], 'w' );
fprintf( fid, '\n#include "mex.h"\n\n#define N_DATA %d\n#define N_INPUT %d\n#define N_PARS %d\n#define N_STATES %d\n#define N_OBSPARS %d\n#define N_ICPARS %d\n#define N_OBS %d\n#define N_TIME %d\n#define SENSDIM %d\n\nvoid objectiveFn(double *obj, double *s, double *p, double *d, double *u );\n\n', nData, nInput, nPars, nStates, nObsPars, nIcPars, nObs, nTime, nStates * ( nStates + nPars ) );
fid = fclose(fid);

if cjac == 1

    % Now that the objective function is computed, we can process the
    % derivatives
    % 
    % dy1 dp1
    % dy2 dp1
    % dy1 dp2
    % dy2 dp2
    % Compute all the derivatives
    disp( 'Generating syms for all state derivatives output' );
    S = sym( zeros( nStates * (nPars+nStates), length( timePts ) ) );
    for a = 1 : length( timePts )
        for b = 1 : nStates * ( nPars + nStates )
            S( b, a ) = sym( sprintf( 'S_%d_%d', b, a ) );
        end
    end

    disp( 'Constructing the Jacobian (model parameters)' );
    jac = sym( zeros( length( obj ), nPars + nObsPars + nIcPars ) );
    for a = 1 : length( obj )    
        disp( sprintf( 'Observable %d/%d', a, length(obj) ) );
        for b = 1 : nPars
            index = length( obj ) * (b-1) + a;

            % Process all partial derivatives with respect to the observables
            % do/dx dx/dp (based on model sensitivities)
            for c = 1 : nStates
                index = ( nStates * (b-1) ) + c;
                curJac = eval(sprintf( 'jacobian(obj(%d),s%d)', a, c ) );
                jac( a, b ) = jac( a, b ) + curJac * S(index,:).';
            end

            % Process partial derivatives directly with respect to the
            % parameters
            % do/dp
            curJac = eval( sprintf( 'diff(obj(%d),p(%d))', a, b ) );
            jac(a,b) = jac(a,b) + curJac;
        end
  
        % Objective function parameters (metapars)
        for b = 1 : nObsPars
            % Process derivatives w.r.t. parameters
            curJac = eval( sprintf( 'diff(obj(%d),o(%d))', a, b ) );
            jac(a,b+nPars) = jac(a,b+nPars) + curJac;
        end

        % Initial condition parameters
        for b = 1 : nIcPars
            % Process all partial derivatives with respect to the observables
            % do/dx dx/dp (based on model sensitivities)
            for c = 1 : nStates
                index = ( nStates * (nPars+icPars(b)-1) ) + c;
                curJac = eval(sprintf( 'jacobian(obj(%d),s%d)', a, c ) );
                jac( a, b+nPars+nObsPars ) = jac( a, b+nPars+nObsPars ) + curJac * S(index,:).';
            end

            % Process derivatives w.r.t. parameters
            % curJac = eval( sprintf( 'diff(obj(%d),i(%d))', a, icPars(b) ) );
            % jac(a,b+nPars+nObsPars) = jac(a,b+nPars+nObsPars) + curJac;
        end
    end
    
    
    disp( 'Writing C file for the jacobian' )
    jac         = jac.';
    c_code      = ccode( jac );
    %c_code      = regexprep( c_code, 'jac\[(\d+)\]\[(\d+)\]',  'jac[($1)*(N_PARS+N_OBSPARS+N_ICPARS)+($2)]' );
    c_code      = regexprep( c_code, 'jac\[(\d+)\]\[(\d+)\]',  'jac[($1)*(N_OBS)+($2)]' );
    c_code      = regexprep( c_code, 's(\d+)_(\d+)',  's[($2-1)*N_STATES+($1-1)]' );
    c_code      = regexprep( c_code, 'S_(\d+)_(\d+)',  'S[($2-1)*SENSDIM+($1-1)]' );
    c_code      = regexprep( c_code, 'p(\d+)',       'p[$1-1]' );
    c_code      = regexprep( c_code, 'u(\d+)',       'u[$1-1]' );    
    c_code      = regexprep( c_code, 'o(\d+)',       'p[N_PARS+$1-1]' );
    c_code      = regexprep( c_code, 'i(\d+)',       'p[N_PARS+N_OBSPARS+$1-1]' );
    c_code      = regexprep( c_code, 'data_(\d+)',   'd[$1-1]' );

    fid         = fopen( [observPath 'ccode/jac.c' ], 'w' );
    fprintf( fid, '#include "objfn.h"\n\n\nvoid jacobian(double *jac, double *s, double *p, double *d, double *u, double *S ) {\n%s\n}\n', c_code );
    fid         = fclose( fid );

    fid = fopen( [observPath 'ccode/jac.h'], 'w' );
    fprintf( fid, '#define CJAC\n\nvoid jacobian(double *obj, double *s, double *p, double *d, double *u, double *S );\n\n', nData, nPars, nStates, nObsPars, nObs, nTime );
    fid = fclose(fid);
else
    fid = fopen( [observPath 'ccode/jac.h'], 'w' );
    fprintf( fid, '\n\n', nData, nPars, nStates, nObsPars, nObs, nTime );
    fid = fclose(fid);
end

% Compiling C function(s)
disp( 'Compiling C functions' );
compileObjective( obsName, cjac, observPath );

disp( 'Done!' );

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
