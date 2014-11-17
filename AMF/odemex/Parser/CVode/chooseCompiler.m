%% Mandatory Settings

% compiler = 1;  % lccwin32
compiler = 2; % msvc
% compiler = 3; % GCC under windows
% compiler = 4; % GCC under linux

% Don't forget to call mex -setup when you switch compiler (not needed for
% GCC)

lapack              = 'libmwlapack.lib';
blas                = 'libmwblas.lib';

%% Common Settings

lccLocation         = [ matlabroot '/sys/lcc' ];

[junk,parserDir]    = strtok( fliplr( fileparts( mfilename( 'fullpath' ) ) ), '/\' );
parserDir           = fliplr( parserDir );
cvodeDir            = [ parserDir '/CVode' ];

%% LCC-Win32
if ( compiler == 1 )
    
    % O2 means optimise for performance, not space!
    flags = '-O2 ';
    
    
    % Don't set these unless you're having trouble \/
    compilerLocation    = [ matlabroot '\sys\lcc' ];
    algebraDir          = [ matlabroot '\extern\lib\win32\lcc' ];
    lapack              = [ algebraDir '\' lapack ];
    blas                = [ algebraDir '\' blas ];
    libraryName         = 'CVODE.lib';
    idaName         	= 'IDA.lib';
    extraflags          = ' ';
end

%% Microsoft Visual C++ 2008
if ( compiler == 2 )
    
    % If you use MSVC, adjust these to the appropriate location \/
    %vsroot = 'D:\Program Files\Microsoft Visual Studio 9.0';
    %netroot = 'C:\WINDOWS\Microsoft.NET';
    %vsroot = 'C:\Program Files (x86)\Microsoft Visual Studio 10.0';
    %netroot = 'C:\Windows\Microsoft.NET';
    vsroot = '';
    netroot = '';
    
    %  \/ Base your choice of optimisations here
    %* P2: G6 is fastest (official builds are G6)
    %* P3: G6 SSE is fastest
    %* P4: G7 SSE2 is fastest
    %* Celeron: Depends on whether your Celeron is P2-based, P3-based, or P4-based.
    %* Athlon XP: G7 may be faster than G7 SSE even though SSE is supported
    %
    % O2 means optimise for performance, not space!
    %
    % -ffast-math very fast math, b
    flags = '-O2 '; % /fp:strict'; 
    
    
    % Don't set these unless you're having trouble \/
    compilerLocation    = [ vsroot '\VC' ];
    if strcmp(computer, 'PCWIN')
        algebraDir          = [ matlabroot '\extern\lib\win32\microsoft' ];
    else
        if strcmp(computer, 'PCWIN64')
            algebraDir          = [ matlabroot '\extern\lib\win64\microsoft' ];    
        else
            disp( 'WARNING: Could not identify computer. Cannot link against lapack/BLAS' );
        end
    end
    lapack              = [ algebraDir '\' lapack ];
    blas                = [ algebraDir '\' blas ]; 
    libraryName         = 'CVODE.lib';
    idaName         	= 'IDA.lib';
    extraflags          = ' ';
end

%% GCC --> Win
if ( compiler == 3 )
    
    % To use the GCC compiler, obtain GNUMEX from
    % http://gnumex.sourceforge.net/
    % and install it in the subdiretory parser/gnumex
    % Follow the instructions, and set up cygwin.
    % Copy the cygwin1.dll in the directory where you want to solve
    % things under windows. Cygwin is used to run linux stuff on windows
    % machines so you can test.
    % Use gnumex to create a .bat file (in the gnumex dir!) with appropriate mex options
    % and reference it by changing this line:
    gnumex              = [ parserDir '\gnumex\mexopts.bat' ];
    flags               = '-ffast-math'; % /fp:strict'; 
    cygwinLib           = 'C:\cygwin\bin\';
    
    
    % Don't set these unless you're having trouble \/
    %vsroot = 'D:\Program Files\Microsoft Visual Studio 9.0';
    %compilerLocation    = [ vsroot '\VC' ];
    algebraDir          = [ matlabroot '\extern\lib\win32\microsoft' ];
    lapack              = [ algebraDir '\' lapack ];
    blas                = [ algebraDir '\' blas ];
    extraflags          = [ '-f ''' gnumex '''' ];
    libraryName         = 'CVODE.a';
    idaName         	= 'IDA.a';
    copyfile( [ cygwinLib, 'cygwin1.dll' ], parserDir );
    
end

%% GCC --> For deployment on Linux stations!
if ( compiler == 4 )
    
    % To use the GCC compiler, obtain GNUMEX from
    % http://gnumex.sourceforge.net/
    % and install it in the subdiretory parser/gnumex
    % Follow the instructions, and set up cygwin.
    % Copy the cygwin1.dll in the directory where you want to solve
    % things under windows. Cygwin is used to run linux stuff on windows
    % machines so you can test.
    % Use gnumex to create a .bat file (in the gnumex dir!) with appropriate mex options
    % and reference it by changing this line:
    gnumex              = [ parserDir '/gnumex/mexopts.bat' ];
    flags               = '-ffast-math'; % /fp:strict'; 
    
    
    % Don't set these unless you're having trouble \/
    %vsroot = 'D:\Program Files\Microsoft Visual Studio 9.0';
    %compilerLocation    = [ vsroot '\VC' ];
    algebraDir          = [ matlabroot '/extern/lib/linux/microsoft' ];
    extraflags          = '';
    libraryName         = 'CVODE.a';
    idaName         	= 'IDA.a';
    
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
