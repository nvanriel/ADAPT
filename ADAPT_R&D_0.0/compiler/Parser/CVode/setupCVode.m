% This file compiles CVode for use with MATLAB

chooseCompiler;
mkdir( [cvodeDir '/tmp'] );

% List of directories to include in the compilation
list = { 'cvodes' 'nvec_ser' 'sundials' };

% Make a list of filenames to include in the compilation
names       = '';
sourceDir   = [ parserDir 'CVode/' ];

for q = 1 : length( list )
    fList = dir( sprintf( '%s/cv_src/src/%s/*.c', sourceDir, list{q} ) );
    
    for l = 1 : length( fList )
        names = sprintf( '%s ''%s/cv_src/src/%s/%s''', names, sourceDir, list{q}, fList(l).name );
    end
end

% for q = 1 : length( list )
%     tmp = ls( sprintf( '%s/cv_src/src/%s/*.c', sourceDir, list{q}  ) );
%     % Under Windows we need to add the directory name
%     % under linux this is already done.
%     if ~isunix
%         tmp = [ repmat( sprintf( '%s/cv_src/src/%s/', sourceDir, list{q} ), size( tmp, 1 ), 1 ), tmp, repmat( ' ', size( tmp, 1 ), 1 )];
%     end
%     
%     [a, b] = size(tmp);
%     
%     names = [ names '  ' reshape( tmp.', 1, a*b ) ];
% end

% Get rid of extra spaces since the compiler seems to dislike these.
nLen = 1;
len = length( names );
while( nLen < len )
    len = nLen;
    names = strrep( names, sprintf( '\n' ), ' ' );
    names = strrep( names, sprintf( '\r\n' ), ' ' );
    names = strrep( names, '  ', ' ' );
    nLen = length( names );
end

if ( compiler < 3 )
    % Compile the CVode source files!
    eval( sprintf( 'mex -v -c -O -outdir ''%s/tmp'' -I''%s/cv_src/include/'' %s COMPFLAGS="$COMPFLAGS %s"', cvodeDir, sourceDir, names, flags ) );
%    eval( sprintf( 'mex %s -v -c -outdir ''%s/tmp'' -I''%s/cv_src/include/'' ''%s'' COMPFLAGS="$COMPFLAGS %s" "%s" "%s"', extraflags, cvodeDir, sourceDir, names, flags, lapack, blas ) );
end

% Bind the object code files into a library.
% To be able to do that the lib.exe needs to be 
% in the system path.
disp('Generating library ...');

% LCCWIN32
if compiler == 1
    disp( 'Compiler: Lcc-win32' );
    eval( sprintf( '!"%s/bin/lcclib" /OUT:"%s\\tmp\\%s" "%s\\tmp\\*.obj"', compilerLocation, cvodeDir, libraryName, cvodeDir ) );
    delete( [ cvodeDir '/tmp/*.obj' ] );
    movefile( [ cvodeDir '/tmp/*.lib' ], [ cvodeDir '/lib' ] );
    rmdir( [ cvodeDir '/tmp' ] )
end

% MSVC
if compiler == 2
    disp( 'Compiler: Microsoft Visual C++' )

    curDir = pwd;
    %cd( [ compilerLocation '\bin\'] )
    
    p = [ sprintf( 'PATH=%s\\Common7\\IDE;%s\\VC\\BIN;%s\\Common7\\Tools;%s\\Framework\\v3.5;%s\\Framework\\v2.0.50727;%s\\VC\\VCPackages\nlib "%s\\tmp\\*.obj" /OUT:"%s\\lib\\%s"\ncd\n', vsroot, vsroot, vsroot, netroot, netroot, vsroot, curDir, curDir, libraryName ) ];
    
    %fid = fopen( [ compilerLocation '\bin\mslibmaker.bat' ], 'w' );
    %    fprintf( fid, '%s\n', p );
    %fclose( fid );  
    
    fid = fopen( [ 'mslibmaker.bat' ], 'w' );
        fprintf( fid, '%s\n', p );
    fclose( fid );  

    dos( 'mslibmaker', '-echo' );
    delete mslibmaker.bat;

    delete( [ cvodeDir '/tmp/*.obj' ] );
    rmdir( [ cvodeDir '/tmp' ] )
end

% GCC win
if compiler == 3
    eval( sprintf( 'mex %s -v -c -outdir ''%s/tmp'' -I''%s/cv_src/include/'' ''%s'' COMPFLAGS="$COMPFLAGS %s" "%s" "%s"', extraflags, cvodeDir, sourceDir, names, flags, lapack, blas ) );

    clear names, tmp;
    names = '';
    tmp = ls( sprintf( '%s\\tmp\\*.obj', cvodeDir ) );
    
    tmp = [ repmat( sprintf( '"%s\\tmp\\', cvodeDir ), size( tmp, 1 ), 1 ), tmp, repmat( '" ', size( tmp, 1 ), 1 )];
    [a, b] = size(tmp);
    names = [ names reshape( tmp.', 1, a*b ) ];

    nLen = 1;
    len = length( names );
    while( nLen < len )
        len = nLen;
        names = strrep( names, '  ', ' ' );
        nLen = length( names );
    end
    
    if ( exist( sprintf( '%s\\lib\\%s', cvodeDir, libraryName ) ) ~= 0 )
        delete( sprintf( '%s\\lib\\%s', cvodeDir, libraryName ) );
        disp( 'Old library deleted and updated with new version' );
    end
    
    eval( ['!' cygwinLib 'ar cr ' sprintf( '"%s\\lib\\%s" %s', cvodeDir, libraryName, names ) ] );
    
    delete( [ cvodeDir '/tmp/*.obj' ] );
    rmdir( [ cvodeDir '/tmp' ] )

end

% GCC linux
if compiler == 4
    eval( strrep( strcat( sprintf( 'mex %s -v -c -outdir ''%s/tmp'' -I''%s/cv_src/include/'' %s CFLAGS="$CFLAGS -fPIC %s"', extraflags, cvodeDir, sourceDir, names, flags ) ), sprintf( '\n' ), ' ' ) );

    clear names;
    names = '';
    tmp = ls( sprintf( '%s/tmp/*.o', cvodeDir ) );
    
    tmp = strrep( tmp, sprintf('\n'), ' ' );
    names = strrep( tmp, sprintf('\t'), ' ' );  

    if ( exist( sprintf( '%s/lib/%s', cvodeDir, libraryName ) ) ~= 0 )
        delete( sprintf( '%s/lib/%s', cvodeDir, libraryName ) );
        disp( 'Old library deleted and updated with new version' );
    end
    ['ar cr ' sprintf( '"%s/lib/%s" %s', cvodeDir, libraryName, strrep( names, '''', '"' ) ) ]
    system( ['ar cr ' sprintf( '"%s/lib/%s" %s', cvodeDir, libraryName, strrep( names, '''', '"' ) ) ] );
    
    delete( [ cvodeDir '/tmp/*.o' ] );
    rmdir( [ cvodeDir '/tmp' ] )

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
