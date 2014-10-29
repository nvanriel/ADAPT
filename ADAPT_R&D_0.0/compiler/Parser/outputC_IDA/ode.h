/*
 Joep Vanlier, 2011

 Licensing:
  Copyright (C) 2009-2011 Joep Vanlier. All rights
  reserved.

  Contact:joep.vanlier@gmail.com

  This file is part of the puaMAT.
   
  puaMAT is free software: you can redistribute it 
  and/or modify it under the terms of the GNU General 
  Public License as published by the Free Software 
  Foundation, either version 3 of the License, or (at 
  your option) any later version.

  puaMAT is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY; without even the 
  implied warranty of MERCHANTABILITY or FITNESS FOR A 
  PARTICULAR PURPOSE.  See the GNU General Public 
  License for more details.
  
  You should have received a copy of the GNU General
  Public License along with puaMAT.  If not, see
  http://www.gnu.org/licenses/
*/
#include "mex.h"
#include "ida.h"
#include "model/dxdtDefs.h"
#include <nvector/nvector_serial.h>
#include <math.h>

#define N_PI  (3.141592653589793)
#define N_EXP (2.7182818284590455)

#if SOLVER == 2  
    #include "idas_lapack.h"
#endif
#if SOLVER == 3
    #include "idas_spgmr.h"
#endif
#if SOLVER == 4
    #include "idas_spbcgs.h"
#endif
#if SOLVER == 5
    #include "idas_sptfqmr.h"
#endif

#ifndef ODE_H
#define ODE_H

struct mVector {
    double  *val;
    int     length;
};

struct mData {
    realtype *u;
    realtype *p;
};

void        grabVectorFromMatlab( struct mVector *vector, const mxArray *prhs );
void        handleError( void *cvode_mem, N_Vector y0, N_Vector yp0, int flag, mxArray *plhs[] );
void        memErr( void *cvode_mem, N_Vector y0, N_Vector yp0, void *pOld, const char *msg );
realtype   *reAllocate2DOutputMemory( realtype *pMem, void *cvode_mem, N_Vector y0, N_Vector yp0, mxArray *plhs, int dim1, int dim2 );

realtype 	interpolate( realtype *time, realtype *data, int n, realtype t, int type );
realtype    maximum( realtype x, realtype y );
realtype    minimum( realtype x, realtype y );
realtype    intPow( realtype x, int y );

#endif
