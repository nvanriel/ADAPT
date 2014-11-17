% M-File to C-file RHS parser
%
% function convertToC_IDA( mStruct, odeInput, dependencies, options )
% 
%   Input arguments:
%     mStruct       - Structure containing state, parameter and input
%                     indices and constants in fields s p u and c
%                     respectively
%     odeInput      - Filename of main input RHS file
%     dependencies  - Filename of files the RHS file depends on
%     (options)     - This argument is optional and can be set with
%                     cParserSet (example: cParserSet( 'blockSize', 5000 ))
%
% ** Note that there is no support for vectors, cell arrays, structures or
% functions with more than one output argument! Also note that in order to
% take powers, use intPow( x, integer exponent ) for integer powers and 
% pow( x, double exponent ). Note that the former results in a considerable
% computational improvement.
%
% Written by J. Vanlier
% Contact: j.vanlier@tue.nl

function convertToC( mStruct, odeInput, dependencies, options, M )
    
    parserPath = fileparts( mfilename( 'fullpath' ) );
    addpath( [ parserPath '/parserDependencies' ], '-begin' );

    if nargin < 1
        disp( 'This file requires at least a structure with variable indices and one input filename' );
    end
    
    l = 'Input filenames: ';
    
    if nargin < 5
        M = eye( length(fieldnames(mStruct.s)) );
    end
    
    %% Basic input checking
    if exist( odeInput ) == 0
        disp( 'Input file does not exist' );
        return;
    else
        l = sprintf( '%s"%s"', l, odeInput );
    end
    
    depNames = {};
    try
        for a = 1 : length( dependencies )
             if exist( dependencies{ a } ) == 0
                 disp( sprintf( 'Dependency file %s does not exist', dependencies{a} ) );
                 return;
             else
                 l = sprintf( '%s, "%s"', l, dependencies{ a } );
                 [jnk b] = fileparts( dependencies{ a } );
                 depNames{ a } = b;
             end
        end
    catch
        if nargin > 2
            if ~isempty( dependencies )
                disp( 'ERROR: Failure processing dependency list. Make sure it is a cell array' );
                return;
            end
        end
    end
    
    disp( sprintf( '\nODE RHS m-file parser\n%s\n', l ) );
       
    %% Grab parser options
    try
        solver = getField( options, 'solver' );
    catch
        solver = 1;
    end
    switch solver
        case 1
            disp( 'Solver: Dense' );
        case 2
            disp( 'Solver: Dense solver with MATLAB BLAS' );
        case 3
            disp( 'Solver: Scaled preconditioned GMRES' );
        case 4
            disp( 'Solver: Bi-CGStab' );
        case 5
            disp( 'Solver: TFQMR' );
        case 10
            disp( 'Solver Adams Moulton order 1-12' );
        otherwise
            disp( 'ERROR: Non existant solver specified. Aborting!' );
            return;
    end

    try
        blockSize = getfield( options, 'blockSize' );
    catch
        blockSize = 1000;
    end
    disp( sprintf( 'Blocksize: %d timepoints', blockSize ) );

    try
        maxErrFail = getfield( options, 'maxErrFail' );
    catch
        maxErrFail = 15;
    end
    disp( sprintf( 'Maximum number of error test failures: %d', maxErrFail ) );
    
    try
        maxConvFail = getfield( options, 'maxConvFail' );
    catch
        maxConvFail = 1000000;
    end
    disp( sprintf( 'Maximum number of convergence failures (solving linear system): %d', maxConvFail ) );
        
    try
        maxStep = getfield( options, 'maxStep' );
    catch
        maxStep = 1000000000;
    end
    disp( sprintf( 'Maximum number of time steps to evaluate: %d', maxStep ) );

	try
		minStep = getField( options, 'minStep' );
	catch
		minStep = 1e-14;
	end
	disp( sprintf( 'Minimum step size: %e', minStep ) );
    
    try
        nonNegative = getField( options, 'nonNegative' );
    catch
        nonNegative = 0;
    end   
    if max( nonNegative ) == 1
        if length( nonNegative ) == length( fieldnames( mStruct.s ) )
            disp( 'Enforce Non Negativity of subset of solutions' );
        else
            disp( 'Warning, Non Negative list should be as long as the number of states. Ignoring Non Negativity flag.' );
            nonNegative = 0;
        end
    else
        disp( 'Not enforcing Non Negativity of the solutions' );
    end
    
    %% Start declaring things we need
    
    odeOutput = [ parserPath '/outputC_IDA/model/dxdt.c' ];
    hOutput = [ parserPath '/outputC_IDA/model/dxdtDefs.h' ];
    expressionTokens = '()[]/*+-^@ %<>,;={}';
    
    try
        convertables = { odeInput, dependencies{:} };
    catch
        convertables = { odeInput };
    end
    
    % Declare and sort the states
    try
        [ states ] = grabFieldNames( mStruct.s );
        [ stateIndices ] = grabIndices( states, mStruct.s );
    catch
        disp( 'ERROR: Input structure requires state indices' );
    end

    % Declare the parameters
    try
        [ parameters, parameterIndices ] = grabFieldNames( mStruct.p );
        [ parameterIndices ] = grabIndices( parameters, mStruct.p );
    catch
        disp( 'ERROR: Input structure requires parameter indices' );
    end
    
    % Declare the constants
    try
        [ constants, constantIndices ] = grabFieldNames( mStruct.c );
        [ constantIndices ] = grabIndices( constants, mStruct.c );
    catch
        disp( 'No constants' );
        constants = {};
    end
    
    % Declare the inputs
    try
        [ inputs, inputIndices ] = grabFieldNames( mStruct.u );
        [ inputIndices ] = grabIndices( inputs, mStruct.u );
    catch
        disp( 'No inputs' );
        inputs = {};
    end
    
    % Currently the number of equations equals the number of states
    nEqs = length( states );
    
    %% Load the files
    for a = 1 : length( convertables )
        try
            [ g{a} ] = textread( convertables{ a }, '%s', 'delimiter', '\n' );
        catch
            disp( sprintf( 'Error! Cannot find file %s', convertables{a} ) );
        end
        
        % Make sure comments are turned C/C++ compatible
        for b = 1 : length( g{a} )
            if findstr( g{a}{b}, '%' ) > 0
                g{a}{b} = strcat( strrep( g{a}{b}, '%', '/*' ), '*/' );  
            end
        end
        g{a} = strrep( g{a}, '~', '!' );
    end
    
    % Remove all lines before function keyword
    for a = 1 : length( convertables )
        b = 1;
        while( 1 )
            if b > length( g{a} )
                disp( sprintf( 'Error! Function %s is missing function keyword! Aborting!\n' ), convertables{a} );
                return;
            end
            if ( findstr( lower( g{a}{b} ), 'function' ) )
                break;
            end
            g{a}(b) = [];
        end
    end
    
    % Find out what name the user used for the different vectors
    [ outVars, inVars ] = analyseFunctionHeader( g{1}{1} );
    timeVar = inVars{1};
    stateVar = inVars{2};
    parVar = inVars{3};
    inVar = inVars{4};
    outVar = outVars{1};

    %% Replace structure references
    for a = 1 : length( convertables )
        for b = 1 : length( g{a} )
            g{a}{b} = replaceStructNames( g{a}{b}, states, stateIndices, '.s' );
            g{a}{b} = replaceStructNames( g{a}{b}, parameters, parameterIndices, '.p' );
            try
                g{a}{b} = replaceStructNames( g{a}{b}, inputs, inputIndices, '.u' );
            catch
            end
            try
                g{a}{b} = replaceStructNames( g{a}{b}, constants, constantIndices, '.c' );
            catch
            end
        end
    end
    
    %% Parse the file
    identifierLists = {{}, {}};
    
    for a = 1 : length( convertables )
        for b = 2 : length( g{ a } )
            [ token, remainder, removedChars ] = strtok2( g{a}{b}, expressionTokens );
            g{a}{b} = '';
            while( ~isempty( remainder ) || ~isempty( token ) || ~isempty( removedChars ) )
                found = 0;
                
                % Ignore comments
                if length( removedChars ) > 1
                    if ~isempty( findstr( removedChars, '//' ) ) || ~isempty( findstr( removedChars, '/*' ) ) 
                        g{a}{b} = strcat( g{a}{b}, removedChars, token, remainder );
                        break;
                    end
                end
                % Remove lines with vector stuff in them
                if strcmp( token, ':' ) || strcmp( lower( token ), 'zeros' )
                    disp( sprintf( 'Warning: Vectorised code detected; [%s] line ignored!', strcat( g{a}{b}, removedChars, token, remainder ) ) );
                    g{a}{b} = '';
                    break;
                end
                if ~isempty( str2num( token ) )
                    found = 1;
                end
                if strcmp( token, 'if' )
                    remainder = sprintf( '%s{', remainder );
                    found = 1;
                end
                if strcmp( token, 'else' );
                    token = sprintf( '} else {', g{a}{b} );
                    found = 1;
                end
                if strcmp( token, 'end' );
                    token = '}';
                    found = 1;
                end                
                if strcmp( token, timeVar )
                    found = 1;
                end
                if strcmp( lower(token), lower(depNames) )
                    found = 1;
                end
                if strcmp( token, stateVar ) | strcmp( token, parVar ) | strcmp( token, inVar ) | strcmp( token, outVar )
                    % Only process assignments
                    tmp = strtok( remainder, ' ' );
                    if strcmp( tmp(1), '(' )
                        if strcmp( token, stateVar )    token = 'stateVars';     end;
                        if strcmp( token, parVar )      token = 'data->p';     end;
                        if strcmp( token, inVar )       token = 'data->u';     end;
                        if strcmp( token, outVar )      token = 'dEqs';     end;
                        [ cal, remainder ] = grabBetweenBrackets( remainder );
                        cal = dec1( cal );
                        token = sprintf( '%s', token );
                        remainder = sprintf( '[%s]%s', cal, remainder );
                        found = 1;
                    end
                end
                if strcmp( token, 'cell' ) |( ( ( exist( token ) == 0 ) | ( exist( token ) == 1 ) ) && ( found == 0 ) )
                    if ~isempty( token )
                        identifierLists{a} = { identifierLists{a}{:}, token };
                    end
                end                   
                g{a}{b} = strcat( g{a}{b}, removedChars, token );
                [ token, remainder, removedChars ] = strtok2( remainder, expressionTokens );
            end
        end
    end
    
    %% Start generating the right hand side file
    c = 1;
    l = '';
    
    l = sprintf( '#include "../dxdt.h"\n\n' );    
    
    for a = 2 : length( convertables )
        [ outVars, inVars, funcName ] = analyseFunctionHeader( g{a}{1} );
        identifierLists{a} = { identifierLists{a}{:}, outVars{:} };
        
        if length( outVars ) == 1
            % Print the function header
            l = sprintf( '%srealtype %s( %s ) {\n\n', l, funcName, printList( inVars, 'realtype ' ) );
            
            % Print the list of identifiers
            l = sprintf( '%s\t%s;\n', l, printUniqueList( identifierLists{a}, inVars ) );
            
            % Print the rest of the file
            for b = 2 : length( g{a} )
                l = sprintf( '%s\t%s\n', l, g{a}{b} );
            end
            l = sprintf( '%s\treturn %s;\n\n}\n\n', l, outVars{ 1 } );
        end
    end
    
    % Print RHS function header
    l = sprintf( '%s\n\nint rhs( realtype t, N_Vector y, N_Vector ydot, N_Vector resid, void *f_data ) {\n\n\tstruct mData *data = ( struct mData * ) f_data;\n\n', l );
    
	% Print the list of identifiers
    l = sprintf( '%s\t%s;', l, printUniqueList( identifierLists{1} ) );

    % Fetch variables
    l = sprintf( '%s\n\trealtype *stateVars;', l );
    l = sprintf( '%s\n\trealtype *ydots;\n', l );
    l = sprintf( '%s\n\trealtype *resids;\n', l );
    l = sprintf( '%s\trealtype\tdEqs[%d];\n', l, nEqs );
       
    % Make a list of derivative variables
    l = sprintf( '%s\n\tstateVars = NV_DATA_S(y);', l );
    l = sprintf( '%s\n\tydots = NV_DATA_S(ydot);\n', l );
    l = sprintf( '%s\n\tresids = NV_DATA_S(resid);\n', l );
    
    % Print the rest of the file
    for b = 2 : length( g{1} )
        l = sprintf( '%s\t%s\n', l, g{1}{b} );
    end
    
    % Build up the residual vector using the mass matrix
    for b = 1 : length( M )
        z = '';
        for c = 1 : length( M )
            if M( b, c ) ~= 0
                z = sprintf( '%s + %d * ydots[%d]', z, M( b, c ), c - 1 );
            end
        end
        l = sprintf( '%s\n\tresids[%d] = %s - dEqs[%d];', l, b - 1, z, b - 1 );
    end
       
    l = sprintf( '%s\n\n\t#ifdef NON_NEGATIVE\n\t\treturn', l );
    
    if max( nonNegative ) == 1
        for a = 1 : length( states ) - 1
            if nonNegative( a ) == 1
                l = sprintf( '%s ( stateVars[%d] < 0.0f ) || ', l, a - 1 );
            end
        end
        if nonNegative( length( states ) ) == 1
            l = sprintf( '%s ( stateVars[%d] < 0.0f )', l, length( states ) - 1 );
        end
    else
        l = sprintf( '%s 0', l );
    end
    
    l = sprintf( '%s;\n\t#else\n\t\treturn 0;\n\t#endif\n\n};\n', l );
    
    mz = 0;
    try
        for a = 1 : length( inputIndices )
            mz = max( [ mz, max( inputIndices{a} ) ] );
        end
    catch
    end
    
    s = sprintf( '\n#define N_STATES %d\n#define N_PARAMS %d\n#define N_INPUTS %d\n#define SOLVER %d\n#define BLOCK_SIZE %d\n\n#define MAX_CONV_FAIL %d\n#define MAX_STEPS %d\n#define MAX_ERRFAILS %d\n#define MIN_STEPSIZE %.30f\n\n', length( states ), length( parameters ), mz, solver, blockSize, maxConvFail, maxStep, maxErrFail, minStep );
    
    if max( nonNegative ) == 1
        s = sprintf( '%s#define NON_NEGATIVE\n', s );
    end

    fid = fopen( odeOutput, 'w' );
        fprintf( fid, '%s\n', l );
    fclose( fid );

    fid = fopen( hOutput, 'w' );
        fprintf( fid, '%s\n', s );
    fclose( fid );        
    
    disp( 'Files generated!' );
    

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
