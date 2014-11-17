% This function converts an SBML file into a MATLAB file, the parser can
% handle. It also returns the initial conditions and all the necessary
% structures to convert to C.
%
% function [ modelStruct, p, x0, u0 ] = SBMLToM( inDir, inFn, outDir, outFn )
%
% Input Arguments:
%       inDir       input directory (location of the SBML files)
%       inFn        input filename
%       outDir      output directory (where to put the M-file)
%       outFn       output filename (of the m-file)
%
% Optional: constantList (cell array of parameters that should be treated as
% constants)
%
% Note: SBML toolbox for MATLAB needs to be installed for this to work!
%       See http://sbml.org/Software/SBMLToolbox
%
% Authors: J Vanlier, R Oosterhof
function [ modelStruct, p, x0, u0 ] = SBMLToM( inDir, inFn, outDir, outFn, constantList, lumpList )

    model = translateSBML( [ inDir '/' inFn ] );
	
    b = 1; c = 1; u0 = [];
    for a = 1 : length( model.species )
        if model.species(a).constant == 0
            x0( c ) = model.species(a).initialConcentration;
            eval( sprintf( 'modelStruct.s.%s = %d;', model.species(a).id, c ) );
            c = c + 1;
        else
            u0( b ) = model.species(a).initialConcentration;
            eval( sprintf( 'modelStruct.u.%s = %d;', model.species(a).id, b ) );
            b = b + 1;
        end
    end
    nStates = c;
    nInputs = b;

    lumpIDs = zeros( length( lumpList ), 1 );
    
    for a = 1 : length( model.compartment )
        eval( sprintf( 'modelStruct.c.%s = %.15f;', model.compartment(1).id, model.compartment(1).size ) );
    end

     c = 1;
     for a = 1 : length( model.reaction )
         try
             for b = 1 : length( model.reaction(a).kineticLaw.parameter )
                     p( c ) = model.reaction(a).kineticLaw.parameter(b).value;
                     eval( sprintf( 'modelStruct.p.%s = %d;', model.reaction(a).kineticLaw.parameter(b).id, c ) );
                     c = c + 1;
             end
         catch
         end
     end
    
    try
        for a = 1 : length( model.rule )
            parOmit{a} = model.rule(a).variable;
            rulesStr{a} = avoidIntegerDivision( strrep( model.rule(a).formula, 'power', 'pow' ) );
        end

        change = 1;
        while( change )
            change = 0;
            for a = 1 : length( rulesStr )
                for b = a : length( rulesStr )
                    if ~isempty( findstr( rulesStr{a}, parOmit{b} ) )
                        disp( 'Switching rules due to interdependency' ); 
                        tmp1 = rulesStr{a};
                        tmp2 = parOmit{a};
                        rulesStr{a}     = rulesStr{b};
                        rulesStr{b}     = tmp1;
                        parOmit{a}      = parOmit{b};
                        parOmit{b}      = tmp2;
                        change = 1;    
                    end
                end
            end
        end
    catch
    end

    % Added by ir. R. Oosterhof altered by ir J. Vanlier
    %if ~isfield( 'modelStruct', 'p'  )
    for a = 1 : length( model.parameter )
        scmp = 0;
        for b = 1 : length( parOmit )
            scmp = scmp | ( strcmp( model.parameter(a).id, parOmit{b} ) );
        end
        
        if ~scmp
            isconstant = 0;
            for d = 1 : length( constantList )
                if findstr( model.parameter(a).id, constantList{d} )
                    eval( sprintf( 'modelStruct.c.%s = %.15f;', model.parameter(a).id, model.parameter(a).value ) );
                    isconstant = 1;
                end
            end

            if ~isconstant
                % If this is in one of the lump lists then it is a lumped
                % parameter
                lumped = 0;
                for q = 1 : length( lumpList )
                    if sum( find( cell2mat( regexp(model.parameter(a).id, lumpList{q} ) ) == 1 ) )
                        % First time this lumped group comes around
                        if lumpIDs(q) == 0
                            lumpIDs(q) =  c;
                            
                            p( c ) = model.parameter(a).value;
                            c = c + 1;
                        end
                        lumped = lumpIDs(q);
                    end
                end
                
                if lumped == 0
                    p( c ) = model.parameter(a).value;
                    eval( sprintf( 'modelStruct.p.%s = %d;', model.parameter(a).id, c ) );
                    c = c + 1;
                else
                    eval( sprintf( 'modelStruct.p.%s = %d;', model.parameter(a).id, lumped ) );
                end
            end
        end
    end

    declarations{ 1 } = sprintf( 'function dx = mymodel2(t, x, p, u, modelStruct)\n' );
    c = 2;
    names = fieldnames( modelStruct.s );
    for a = 1 : length( names )
        declarations{ c } = sprintf( '\t%s = x( modelStruct.s.%s );\n', names{ a }, names{ a } );
        c = c + 1;
    end
    
    try
        names = fieldnames( modelStruct.u );
        for a = 1 : length( names )
            declarations{ c } = sprintf( '\t%s = u( modelStruct.u.%s );\n', names{ a }, names{ a } );
            c = c + 1;
        end
    catch
    end
    
    names = fieldnames( modelStruct.c );
    for a = 1 : length( names )
        declarations{ c } = sprintf( '\t%s = modelStruct.c.%s;\n', names{ a }, names{ a } );
        c = c + 1;
    end
    
    names = fieldnames( modelStruct.p );
    for a = 1 : length( names )
        declarations{ c } = sprintf( '\t%s = p( modelStruct.p.%s );\n', names{ a }, names{ a } );
        c = c + 1;
    end
	
    try
        for a = 1 : length( rulesStr )
            rules{a} = sprintf( '\t%s = %s;\n', parOmit{a}, rulesStr{a} );
        end
    catch
        rules = {};
    end

    names = fieldnames( modelStruct.s );
    for a = 1 : nStates - 1
        odes{ a } = sprintf( '\tdx( modelStruct.s.%s ) = ', names{a} );
    end

    for a = 1 : length( model.reaction )
        for b = 1 : length( model.reaction(a).reactant )
            try
                speciesID = eval( sprintf( 'modelStruct.s.%s', model.reaction(a).reactant(b).species ) );
                odes{ speciesID } = sprintf( '%s - %d * %s', odes{ speciesID }, model.reaction(a).reactant(b).stoichiometry, model.reaction(a).id );
            catch
            end
        end
        for b = 1 : length( model.reaction(a).product )
            try
                speciesID = eval( sprintf( 'modelStruct.s.%s', model.reaction(a).product(b).species ) );
                odes{ speciesID } = sprintf( '%s + %d * %s', odes{ speciesID }, model.reaction(a).product(b).stoichiometry, model.reaction(a).id );
            catch
            end
        end
    end

    for a = 1 : nStates - 1
        % Added by ir. R. Oosterhof
        if isspace( odes{ a }(end) )
            odes{ a } = sprintf( '%s0;\n', odes{ a } );
        else
        %
            odes{ a } = sprintf( '%s;\n', odes{ a } );
        end
    end

    for a = 1 : length( model.reaction )
        reactions{a} = sprintf( '\t%s = %s;\n', model.reaction(a).id, model.reaction(a).kineticLaw.math );
    end
    
    for a = 1 : length( model.functionDefinition )
        [ junk, tok ] = strtok( model.functionDefinition.math, '(' );
        [ toka, rema ] = strtok( tok(2:end-1), '(' );
        commas = findstr( toka, ',' );
        inVars = toka( 1 : commas( end ) - 1 );
        func = [ toka( commas( end ) + 1 : end ) rema ];
        
        funcNames{ a } = model.functionDefinition.id;
        funcs{ a } = sprintf( 'function returnedValue = %s( %s )\n\n\treturnedValue = %s;', model.functionDefinition.id, inVars, func );
    end

    odefile = [ declarations{:} rules{:} sprintf( '\n\n\t%%%% Flux equations\n' ) reactions{:} sprintf( '\n\n\t%%%% State equations\n' ) odes{:} sprintf( '\n\n\tdx = dx(:);' ) ];

    try
        d = fopen( [ outDir '/' outFn ], 'w' );
        fprintf( d, odefile );
        fclose( d );
    
        if exist( 'funcNames' ) ~= 0
            for a = 1 : length( funcNames )
                d = fopen( [ outDir '/' funcNames{ a } '.m' ], 'w' );
                fprintf( d, funcs{ a } );
                fclose( d );
            end
        end
    catch
        disp( 'Error writing file: Correct path?' );
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
