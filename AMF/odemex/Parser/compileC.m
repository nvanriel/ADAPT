% This function compiles the ODE file
%
% function compileC( outputName )
%
%   Input arguments
%      outputName    - filename without extension that specifies the name
%                      of the binary.
%
% Written by J. Vanlier
% Contact: j.vanlier@tue.nl

function compileC( outputName, IDA )

    DAE = 0;
    if nargin > 1
        if IDA == 1
            DAE = 1;
        end
    end

    compilerPath = fileparts( mfilename( 'fullpath' ) );
    addpath( [ compilerPath '/CVode' ] );
    tempPath = [ compilerPath '/temp' ];
    eval( 'chooseCompiler' );

    if nargin == 0
        disp( 'Please specify an output name for the MEX file (without extension)' );
        return;
    end
      
    if DAE == 0
        eval( 'chooseCompiler' );
        if ~isunix
            eval(sprintf('mex %s COMPFLAGS="$COMPFLAGS %s" -output %s -I"%s" "%s" "%s" "%s" "%s%s"', extraflags, flags, outputName, [compilerPath '/CVode/cv_src/include'], [compilerPath '/outputC/mexG.c'], [compilerPath '/outputC/ode.c'], [compilerPath '/outputC/model/dxdt.c'], [compilerPath '/CVode/lib/'], libraryName ) );    
        else
			eval(sprintf('mex %s CLIBS="\\$CLIBS -L./" COMPFLAGS="\\$COMPFLAGS %s -fPIC" -output %s -I"%s" "%s" "%s" "%s" "%s%s"', extraflags, flags, outputName, [compilerPath '/CVode/cv_src/include'], [compilerPath '/outputC/mexG.c'], [compilerPath '/outputC/ode.c'], [compilerPath '/outputC/model/dxdt.c'], [compilerPath '/CVode/lib/'], libraryName ) );
        end
    else
        eval( 'chooseCompiler' );
        if ~isunix
            eval(sprintf('mex %s COMPFLAGS="$COMPFLAGS %s" -output %s -I"%s" "%s" "%s" "%s" "%s%s"', extraflags, flags, outputName, [compilerPath '/CVode/ida_src/include'], [compilerPath '/outputC_IDA/mexG.c'], [compilerPath '/outputC_IDA/ode.c'], [compilerPath '/outputC_IDA/model/dxdt.c'], [compilerPath '/CVode/lib/'], idaName ) );    
        else
            eval(sprintf('mex %s COMPFLAGS="$COMPFLAGS %s -fPIC" -output %s -I"%s" "%s" "%s" "%s" "%s%s"', extraflags, flags, outputName, [compilerPath '/CVode/ida_src/include'], [compilerPath '/outputC_IDA/mexG.c'], [compilerPath '/outputC_IDA/ode.c'], [compilerPath '/outputC_IDA/model/dxdt.c'], [compilerPath '/CVode/lib/'], idaName ) );
            
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
