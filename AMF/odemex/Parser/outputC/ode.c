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
#include "ode.h"
#include "model/dxdtDefs.h"

void        grabVectorFromMatlab( struct mVector *vector, const mxArray *prhs ) {
    if ( mxIsDouble( prhs ) ) {
        vector->length   = mxGetN( prhs ) * mxGetM( prhs );
        vector->val      = mxGetPr( prhs );
    } else {
        mexErrMsgTxt( "ERROR: Check your parameters! Are they all doubles?" );
    }
}

realtype interpolate( realtype *time, realtype *data, int n, realtype t, int type ) {
    
    realtype *deriv2;
    realtype val;
    
    int max             = n-1;
    int min             = 0;
    int cur             = max/2;

    double a, b, h, tmp;

    /* Out of bounds? */
    if ( t >= time[ max ] )
        return data[ n-1 ];
    else if ( t <= time[ min ] )
        return data[ 0 ];

    /* Where are we? */
    while ( min != max - 1 )
    {
        if ( time[ cur ] <= t )
            min = cur;
        else
            max = cur;

        cur = min + ( max - min ) / 2;
    }

    switch( type )
    {
        /* Piecewise */
        case 0:
            val = data[ min ];
            return val;
            break;
        /* Linear Interpolation */
        case 1:
            val = data[min] + ( t - time[min] ) * ( data[max] - data[min] ) / ( time[max] - time[min] );
            return val;
            break;
        /* Spline Interpolation */
        case 2:
            deriv2 = &data[n];
            h = time[max] - time[min];
            a = ( time[ max ] - t ) / h;
            b = ( t - time[ min ] ) / h;
            val = a * data[ min ] + b * data[ max ] + ( ( a * a * a - a ) * deriv2[ min ] + ( b * b * b - b ) * deriv2[ max ] ) * ( h * h ) / 6.0;
            return val;
            break;
    }
}

realtype tpow(realtype x, unsigned int y) {
    realtype z = y&1? x : 1;
    while(y >>= 1) {
        x *= x;
        if(y & 1) z *= x;
	}
	return z;
}

realtype intPow( double x, int y ) {
    if(y < 0)
        return 1.0/tpow(x, -y);
    else
        return tpow(x, y);
}

realtype maximum( realtype a, realtype b ) {
    return (a > b ? a : b);
}

realtype minimum( realtype a, realtype b ) {
    return (a > b ? b : a);
}

void        memErr( void *cvode_mem, N_Vector y0, void *pOld, const char *msg ) {
    N_VDestroy_Serial( y0 );
    CVodeFree( &cvode_mem );
    mxFree( pOld );
    mexErrMsgTxt( msg );
}

void        handleError( void *cvode_mem, N_Vector y0, int flag, mxArray *plhs[], int nrhs, int sensitivity, N_Vector *yS0, realtype *sensitivities, struct mData *data ) {
    
    #ifdef DEBUG
        long int temp;
        realtype tempreal;
    #endif
    
	#ifdef DEBUG
        printf( "<<< DEBUG OUTPUT >>>\n" );
        printf( "PARAMETERS: \n" );
        for ( temp = 0; temp < N_PARAMS; temp++ ) {
            printf( "P(%d) = %f\n", temp, data->p[ temp ] );
        }
        CVodeGetNumSteps(cvode_mem, &temp);
        printf( "Number of steps taken by the solver: %d\n", temp );
        CVodeGetNumErrTestFails(cvode_mem, &temp);
        printf( "Number of local error test failures: %d\n", temp );
        CVodeGetLastStep(cvode_mem, &tempreal);
        printf( "Last stepsize: %f\n", tempreal );
        CVodeGetCurrentStep(cvode_mem, &tempreal);
        printf( "Last step: %f\n", tempreal );        
	#endif                
                
    if ( sensitivity == 1 ) {
        if ( nrhs < 7 ) free( sensitivities );
		free( data->p );
        N_VDestroyVectorArray_Serial( yS0, N_STATES + N_PARAMS );
		if ( plhs[2] != NULL ) mxDestroyArray(plhs[2]);
    }
    
    if ( plhs[1] != NULL ) mxDestroyArray(plhs[1]);
    if ( plhs[0] != NULL ) mxDestroyArray(plhs[0]);

    N_VDestroy_Serial( y0 );
    /*printf( "Freeing..." );*/
    /*CVodeFree( &cvode_mem );*/
    /*printf( "Success!\n" );*/
    
	switch( flag ) {
        case CV_MEM_NULL:
            printf( "ERROR: No memory was allocated for cvode_mem\n" );
            break;
        case CV_NO_MALLOC:
          printf( "ERROR: Forgot or failed CVodeInit\n" );
          break;
        case CV_ILL_INPUT:
          printf( "ERROR: Input for CVode was illegal\n" );
          break;
        case CV_TOO_CLOSE:
          printf( "ERROR: Initial time too close to final time\n" );
          break;
        case CV_TOO_MUCH_WORK:
          printf( "ERROR: Solver took maximum number of internal steps, but hasn't reached t_out\n" );
          break;
        case CV_TOO_MUCH_ACC:
          printf( "ERROR: Could not attain desired accuracy\n" );
          break;
        case CV_ERR_FAILURE:
          printf( "ERROR: Error tests failed too many times\n" );
          break;                      
        case CV_CONV_FAILURE:
          printf( "ERROR: Convergence failure in solving the linear system\n" );
          break;
        case CV_LINIT_FAIL:
          printf( "ERROR: Linear solver failed to initialize\n" );
          break;
        case CV_LSETUP_FAIL:
          printf( "ERROR: Linear solver setup failed\n" );
          break;
        case CV_RHSFUNC_FAIL:
          printf( "ERROR: Right hand side failed in an unrecoverable manner\n" );
          break;
        case CV_REPTD_RHSFUNC_ERR:
          printf( "ERROR: Convergence test failures occured too many times in RHS\n" );
          break;
        case CV_UNREC_RHSFUNC_ERR:
          printf( "ERROR: Unrecoverable error in the RHS\n" );
          break;
        case CV_RTFUNC_FAIL:
          printf( "ERROR: Rootfinding function failed!\n" );
          break;
        default:
          printf( "ERROR: I have no idea what's going on :(\n" );
          break;
    }
    
    mexErrMsgTxt( "Aborting" );
}

realtype    *reAllocate2DOutputMemory( realtype *pMem, void *cvode_mem, N_Vector y0, mxArray *plhs, mwSize dim1, mwSize dim2 ) {
    void            *pOld;
    
    pOld  = pMem;
    pMem  = mxRealloc( pMem, sizeof( realtype ) * dim1 * dim2 );
    
    if ( pMem == NULL ) memErr( cvode_mem, y0, pOld, "ERROR: Insufficient memory for reallocation during simulation loop!" );
    
    mxSetPr( plhs, pMem );
    mxSetM( plhs, dim1 );
    mxSetN( plhs, dim2 );

    return pMem;
}
