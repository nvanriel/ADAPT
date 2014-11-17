
%modelStruct = mStruct;
eval( sprintf( '%s = mStruct;', structVar ) );

jacFileName = [ parserPath '/outputC/model/aJac.c' ];

disp( 'Computing RHS derivatives ...' );
for a = 1 : nStates
    eval( sprintf( 'syms x_%d;', a - 1 ) );
    eval( sprintf( 'x(%d) = x_%d;', a, a - 1 ) );
end

try
    for a = 1 : length( fieldnames( mStruct.u ) )
        eval( sprintf( 'syms u_%d;', a - 1 ) );
        eval( sprintf( 'u(%d) = u_%d;', a, a - 1 ) );
    end
catch
end

for a = 1 : nStates + nPars
    for b = 1 : nStates
        eval( sprintf( 'syms s_%d_%d;', a - 1 , b - 1 ) );
        eval( sprintf( 'S(%d, %d) = s_%d_%d;', b, a, a - 1, b - 1) );
    end
end

for a = 1 : nPars
    eval( sprintf( 'syms p_%d;', a - 1 ) );
    eval( sprintf( 'p(%d) = p_%d;', a, a - 1 ) );
end

m_file = textread( odeInput, '%s', 'delimiter', '\n' );

m_file = sprintf( '%s\n', m_file{2:end} );
eval( m_file );

for a = 1 : nStates
    for b = 1 : nStates
        dfdy( b, a ) = diff( dx(a), x(b) );
    end
end

for a = 1 : nStates
    for b = 1 : nPars
        dfdp( a, b ) = diff( dx(a), p(b) );
    end
end

for a = 1 : nStates
    dfdp( a, a+nPars ) = 0;
end

if ( aJac == 1 )
    
    %% Generate the analytical sensitivity equations
    disp( 'Generating sensitivity equations ...' );
    ccode( ( dfdy.' * S + dfdp ).', 'file', jacFileName );

    disp( 'Reading sensitivity equation C-file' );
    c_file = textread( jacFileName, '%s', 'delimiter', '\n' );

    disp( 'Replacing state names' );
    c_file = regexprep( c_file, 'MatrixWithNoName\[(\d*)\]', 'NV_DATA_S(ySdot[$1])' );
    c_file = regexprep( c_file, 'p_(\d*)', 'data->p[$1]' );
    c_file = regexprep( c_file, 'u_(\d*)', 'data->u[$1]' );
    c_file = regexprep( c_file, 'x_(\d*)', 'stateVars[$1]' );
    c_file = regexprep( c_file, 's_(\d*)_(\d*)', 'NV_DATA_S(yS[$1])[$2]' );
    c_file = regexprep( c_file, '^t0 = ', '' );

    fullstring = sprintf( '%s\n', c_file{:} );

    [startIndex, endIndex, tokIndex, matchStr, tokenStr] = regexp( fullstring, 't(\d*)' );

    maxT = 0;
    for a = 1 : length( tokenStr )
        val = str2num( tokenStr{a}{1} );
        maxT = max( [ val, maxT ] );
    end

    preString = sprintf('int sensRhs (int Ns, realtype t, N_Vector y, N_Vector ydot, N_Vector *yS, N_Vector *ySdot, void *user_data, N_Vector tmp1, N_Vector tmp2) {\n\n');
    for a = 1 : maxT
        preString = sprintf( '%srealtype t%d;', preString, a );
    end
    postString = sprintf( '\nstruct mData *data = ( struct mData * ) user_data;\nrealtype *stateVars;\nstateVars = NV_DATA_S(y);\n\n' );
    sensRHS = sprintf( '%s\n%s\n%s\nreturn 0;\n};\n', preString, postString, fullstring );

else
    sensRHS = '';
end

if ( fJac == 1 )
    %% Analytical Jacobian
    disp( 'Generating jacobian ...' );
    %ccode( (dfdy.').', 'file', jacFileName );
    ccode( (dfdy.').', 'file', jacFileName );
    %ccode( (sym(0).').', 'file', jacFileName );

    disp( 'Reading jacobian C-file' );
    c_file = textread( jacFileName, '%s', 'delimiter', '\n' );

    disp( 'Replacing state names' );
    c_file = regexprep( c_file, 'MatrixWithNoName\[(\d*)\]', 'DENSE_COL(Jac,$1)' );
    c_file = regexprep( c_file, 'p_(\d*)', 'data->p[$1]' );
    c_file = regexprep( c_file, 'u_(\d*)', 'data->u[$1]' );
    c_file = regexprep( c_file, 'x_(\d*)', 'stateVars[$1]' );
    c_file = regexprep( c_file, '^t0 = ', '' );

    fullstring = sprintf( '%s\n', c_file{:} );

    [startIndex, endIndex, tokIndex, matchStr, tokenStr] = regexp( fullstring, 't(\d*)' );

    maxT = 0;
    for a = 1 : length( tokenStr )
        val = str2num( tokenStr{a}{1} );
        maxT = max( [ val, maxT ] );
    end

    preString = sprintf('int fJac (long int N, realtype t, N_Vector y, N_Vector fy, DlsMat Jac, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3) {\n\n');
    for a = 1 : maxT
        preString = sprintf( '%srealtype t%d;', preString, a );
    end
    postString = sprintf( '\nstruct mData *data = ( struct mData * ) user_data;\nrealtype *stateVars;\nstateVars = NV_DATA_S(y);\n\n' );
    sensRHS = sprintf( '%s%s\n%s\n%s\nreturn 0;\n};\n', sensRHS, preString, postString, fullstring );
end