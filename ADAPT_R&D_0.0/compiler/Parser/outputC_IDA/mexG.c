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
#include "dxdt.h"
#include "time.h"
#include "string.h"

const int numInputArgs  = 5;
const int numOutputArgs = 1;

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
   
  time_t                tStart, tEnd;
  struct mVector        t;
  struct mVector        tol;
  struct mData          data;
  int                   k, p;
  int                   nBlocks;
  realtype              t0;
  realtype              y[ N_STATES ];
  realtype		yd[ N_STATES ];
  realtype              *yOutput;
  realtype              *tOutput;
  int                   mSize;
  
  int                   sensitivity;
  
  /* Structures required for IDA */
  int                   flag;
  N_Vector              y0              = NULL;
  N_Vector              yp0             = NULL;
  N_Vector              *yS0            = NULL;
  void                  *cvode_mem      = NULL;
  void                  *pData          = NULL;
  realtype              tret;
  
  /* Function pointer for the RHS */
  int                   (*f)(realtype t, N_Vector y, N_Vector ydot, N_Vector rr, void *f_data) = &rhs;
  
  if (nrhs == 0) {
      printf( "Call function as:\ny = funcName(t, y0[%d], p[%d], u[%d], [reltol, abstol, maxtime])\n", N_STATES, N_PARAMS, N_INPUTS );
      return;
  }
   
  if ( nrhs < numInputArgs ) mexErrMsgTxt( "ERROR: Incorrect number of input arguments\nFormat should be: (t, y0, x, u, [reltol, abstol, max_integration_time])\n" );
  
  /* Check input dimensions */
  if ( mxGetNumberOfElements( prhs[1] ) != N_STATES ) {
    printf( "ERROR: Initial condition vector has incorrect length! Expected %d, found %d", N_STATES, mxGetNumberOfElements( prhs[1] ) );
    mexErrMsgTxt( "" );
  }
  if ( mxGetNumberOfElements( prhs[2] ) != N_PARAMS ) {
      printf( "ERROR: Parameter vector has incorrect length! Expected %d, found %d", N_PARAMS, mxGetNumberOfElements( prhs[2] ) );
      mexErrMsgTxt( "" );
  }
  if ( mxGetNumberOfElements( prhs[3] ) != N_INPUTS ) {
      printf( "ERROR: Input vector has incorrect length! Expected %d, found %d", N_INPUTS, mxGetNumberOfElements( prhs[3] ) );
      mexErrMsgTxt( "" );
  }
  if ( mxGetNumberOfElements( prhs[4] ) != 3 ) {
      mexErrMsgTxt( "ERROR: Tolerance vector should be of the form [ relative tolerance, absolute tolerance, maximal time allowed for integration in seconds ]" );
  }
  
  /* Grab vectors for own use from MATLAB */
  grabVectorFromMatlab( &t,         prhs[0] );
  grabVectorFromMatlab( &tol,       prhs[4] );
  
  if ( t.length < 1 )
      mexErrMsgTxt( "ERROR: Time vector should be at least one element. Either provide a single time to obtain a single value at time t, a begin and end time if the solver is allowed to determine the timesteps or a series of timepoints at which to compute the solution." );
  
  sensitivity = 0;
  if ( nrhs > 5 ) {
	mexErrMsgTxt( "ERROR: Sensitivity analysis is currently not supported for DAE problems." );
  }

  if ( prhs[3] != NULL )
	data.u = mxGetPr( prhs[3] );
  else
	data.u = NULL;

  /* Set parameter pointer to matlab structure */
  data.p = mxGetPr( prhs[2] );
  /* Copy initial condition to local structure */
  memcpy( y, mxGetPr( prhs[1] ), sizeof( realtype ) * mxGetNumberOfElements( prhs[1] ) );
  memset( yd, 0, sizeof( realtype ) * mxGetNumberOfElements( prhs[1] ) );
  y0 	= N_VMake_Serial( N_STATES, y ); /* Warning, realtype has to be double for this */
  yp0 	= N_VMake_Serial( N_STATES, yd ); /* Warning, realtype has to be double for this */

  /* Compute appropriate initial condition for ydot */
  f(0, y0, yp0, yp0, &data);
  for ( k = 0; k < N_STATES; k++ ) 
	NV_DATA_S(yp0)[k] = - NV_DATA_S(yp0)[k];

  /* Set begin time */
  if ( t.length == 1 )
    t0 = 0.0;
  else
    t0 = t.val[0];

  /* Start up IDA */
  cvode_mem     = IDACreate( );

  /* Initialise IDA */
  if ( IDAInit( cvode_mem, f, t0, y0, yp0 ) != IDA_SUCCESS ) {
      N_VDestroy_Serial( y0 );
      N_VDestroy_Serial( yp0 );
      mexErrMsgTxt( "ERROR: Failed to initialise IDA" );
  }

  /* Specify tolerances */
  if ( IDASStolerances( cvode_mem, tol.val[0], tol.val[1] ) != IDA_SUCCESS ) {
      N_VDestroy_Serial( y0 );
      N_VDestroy_Serial( yp0 );
      IDAFree( &cvode_mem );
      mexErrMsgTxt( "ERROR: Failed to set tolerances" );
  }

  IDASetMinStep( cvode_mem, MIN_STEPSIZE );
  IDASetMaxConvFails( cvode_mem, MAX_CONV_FAIL );
  IDASetMaxNumSteps( cvode_mem, MAX_STEPS );
  IDASetMaxErrTestFails( cvode_mem, MAX_ERRFAILS );
  IDASetMaxTime( cvode_mem, tol.val[2] );

  #if SOLVER == 1
    /* Attach dense linear solver module */
    if ( IDADense( cvode_mem, N_STATES ) != IDA_SUCCESS ) {
          N_VDestroy_Serial( y0 );
	  N_VDestroy_Serial( yp0 );
          IDAFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }
  #endif
  #if SOLVER == 2
    /* Use LAPACK solver */
    if ( IDALapackDense( cvode_mem, N_STATES ) != IDA_SUCCESS ) {
          N_VDestroy_Serial( y0 );
	  N_VDestroy_Serial( yp0 );
          IDAFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  #if SOLVER == 3
    /* Use scaled preconditioned GMRES */
    if ( IDASpgmr( cvode_mem, PREC_BOTH, 0 ) != IDA_SUCCESS ) {
          N_VDestroy_Serial( y0 );
	  N_VDestroy_Serial( yp0 );
          IDAFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  #if SOLVER == 4
    /* Use preconditioned Bi-CGStab solver */
    if ( IDASpbcg( cvode_mem, PREC_BOTH, 0 ) != IDA_SUCCESS ) {
          N_VDestroy_Serial( y0 );
	  N_VDestroy_Serial( yp0 );
          IDAFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  #if SOLVER == 5
    /* Use preconditioned TFQMR iterative solver */
    if ( IDASptfqmr( cvode_mem, PREC_BOTH, 0 ) != IDA_SUCCESS ) {
          N_VDestroy_Serial( y0 );
	  N_VDestroy_Serial( yp0 );
          IDAFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  
/* Current implementation keeps tolerances the same for all vectors
  if ( IDASVTolerances( cvode_mem, reltol, abstol ) != IDA_SUCCESS ) {
      mexErrMsgTxt( "ERROR: Failed to set SV tolerances" );
  }*/

  /*  We need to pass our parameters and inputs to the ODE file */
  pData = &data;
  if ( IDASetUserData( cvode_mem, pData ) != IDA_SUCCESS ) {
      mexErrMsgTxt( "ERROR: Failed passing parameters and initial conditions" );
  }
 
  IDASetLineSearchOffIC( cvode_mem, 1 );
  IDASetMaxNumStepsIC( cvode_mem, 100 );
  IDASetMaxNumJacsIC( cvode_mem, 100 );
  IDASetMaxNumItersIC( cvode_mem, 100 );

  // flag = IDACalcIC( cvode_mem, IDA_Y_INIT, 0.001 );
  // if ( ( flag < 0 ) && ( flag != IDA_NO_RECOVERY ) ) handleError( cvode_mem, y0, yp0, flag, plhs );

  /* Start the timer */
  time( &tStart );
  
  if ( t.length == 2 ) {
      nBlocks   = 1;
      mSize     = nBlocks * BLOCK_SIZE;
      
      /* No steps were specified, just begin and end (dynamic memory allocation) */
      if ( nlhs > 0 ) mxDestroyArray(plhs[0]);
      plhs[0] = mxCreateDoubleMatrix( 1, BLOCK_SIZE, mxREAL );
      tOutput = mxGetPr(plhs[0]);
      tOutput[0] = t.val[0];
      
      if ( nlhs > 1 ) mxDestroyArray(plhs[1]);
      plhs[1] = mxCreateDoubleMatrix( N_STATES, BLOCK_SIZE, mxREAL );
      yOutput = mxGetPr(plhs[1]);
      memcpy( &yOutput[0], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );

      p = 0; k = 0;
      tret = t.val[0];
      while ( tret < t.val[1] )
      {
        p = p + N_STATES; k++;
        flag = IDASolve( cvode_mem, t.val[1], &tret, y0, yp0, IDA_ONE_STEP );
        if ( flag < 0 ) handleError( cvode_mem, y0, yp0, flag, plhs );
      
        /* Check if the memory is still sufficient to store the output */
        if ( ( k + 1 ) > mSize ) {
            /* If we run out of memory, increase the storage size */
            nBlocks ++;
            mSize     = nBlocks * BLOCK_SIZE;
            
            /* We're not done yet so resize the block */
            tOutput = reAllocate2DOutputMemory( tOutput, cvode_mem, y0, yp0, plhs[0], 1, mSize );
            yOutput = reAllocate2DOutputMemory( yOutput, cvode_mem, y0, yp0, plhs[1], N_STATES, mSize );
        }
        
        /* Fetch the output */
        memcpy( &yOutput[p], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );
        tOutput[k] = tret;
        time( &tEnd );
        if ( difftime( tEnd, tStart ) > tol.val[2] ) {
            printf( "WARNING: Simulation time exceeded! Aborting simulation at t = %e\n", tret );
            break;
        }
        
      }
      if ( nBlocks > 1 ) {
        printf( "WARNING: Required %d memory reallocations. Consider increasing block size.\n\n", nBlocks );
      }
      
      /* After we are done simulating, we tighten the memory block to the true size */
      tOutput = reAllocate2DOutputMemory( tOutput, cvode_mem, y0, yp0, plhs[0], 1, k + 1 );
      yOutput = reAllocate2DOutputMemory( yOutput, cvode_mem, y0, yp0, plhs[1], N_STATES, k + 1 );      
      
  } else {
      /* Only one time point */
      if ( t.length == 1 ) {
          
          /* Steps were specified --> Static memory allocation (faster) */
      	  if ( nlhs > 0 ) mxDestroyArray(plhs[0]);
          plhs[0]   = mxCreateDoubleMatrix( 1, 1, mxREAL );
          tOutput   = mxGetPr(plhs[0]);
	 	  if ( nlhs > 1 )  mxDestroyArray(plhs[1]);
          plhs[1]   = mxCreateDoubleMatrix( N_STATES, 1, mxREAL );
          yOutput   = mxGetPr(plhs[1]);
          tret      = 0.0;
          
          /* Simulate up to a point */                
          flag = IDASolve( cvode_mem, t.val[0], &tret, y0, yp0, IDA_NORMAL );
          if ( flag < 0 ) handleError( cvode_mem, y0, yp0, flag, plhs );

          memcpy( &yOutput[0], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );
          tOutput[0] = tret;
      } else {
          /* Steps were specified --> Static memory allocation (faster) */
	  if ( nlhs > 0 ) mxDestroyArray(plhs[0]);
          plhs[0]       = mxCreateDoubleMatrix( 1, t.length, mxREAL );
          tOutput       = mxGetPr(plhs[0]);
          tOutput[0]    = t.val[0];
          tret          = t.val[0];

	  if ( nlhs > 1 )  mxDestroyArray(plhs[1]);
          plhs[1]       = mxCreateDoubleMatrix( N_STATES, t.length, mxREAL );
          yOutput       = mxGetPr(plhs[1]);
          
          memcpy( &yOutput[0], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );

          /* Fixed steps were specified */
          p = N_STATES;
                   
          for ( k = 1; k < t.length; k++ ) {
              flag = IDASolve( cvode_mem, t.val[k], &tret, y0, yp0, IDA_NORMAL );
              if ( flag < 0 ) handleError( cvode_mem, y0, yp0, flag, plhs );

              /* Fetch the output */
              memcpy( &yOutput[p], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );
              p = p + N_STATES;
              tOutput[k] = t.val[k];

              time( &tEnd );
              if ( difftime( tEnd, tStart ) > tol.val[2] ) {
                printf( "WARNING: Simulation time exceeded! Aborting simulation", t.val[k] );
                tOutput = reAllocate2DOutputMemory( tOutput, cvode_mem, y0, yp0, plhs[0], 1, k );
                yOutput = reAllocate2DOutputMemory( yOutput, cvode_mem, y0, yp0, plhs[1], N_STATES, k );            
                break;
              }
          }
      }
  }  
  N_VDestroy_Serial( y0 );
  N_VDestroy_Serial( yp0 );  

  /* Free IDA memory */
  IDAFree( &cvode_mem );
  
  /* If we desire only one output, we probably meant the solution array
     since it is pretty pointless to output the time array */
  if ( nlhs == 1 ) {
      mxDestroyArray( plhs[0] );
      plhs[0] = plhs[1];
  }   
  
}



