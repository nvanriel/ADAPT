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
  int                   k, p, q, ind;
  int                   nBlocks;
  realtype              t0;
  realtype              y[ N_STATES ];
  realtype              *yOutput;
  realtype              *tOutput;
  int                   mSize;
  
  int                   sensitivity;
  double                *sensitivities;
  double                *sensitivityOutputs;
  double                *tols;
  unsigned int          sensitivityBlock;
  size_t                sensitivityBlockSize;
  int                   *sParList;
  
  /* Structures required for CVode */
  int                   flag;
  N_Vector              y0              = NULL;
  N_Vector              *yS0            = NULL;
  void                  *cvode_mem      = NULL;
  void                  *pData          = NULL;
  realtype              tret;
  
  /* Function pointer for the RHS */
  int                   (*f)(realtype t, N_Vector y, N_Vector ydot, void *f_data) = &rhs;
  
  /* Function pointer for the analytic jacobian of the right hand side */
  #ifdef AJAC
  int           		(*g)(int Ns, realtype t, N_Vector y, N_Vector ydot, N_Vector *yS, N_Vector *ySdot, void *user_data, N_Vector tmp1, N_Vector tmp2) = &sensRhs;
  #endif
  
  #ifdef FJAC
  int                   (*fj)(long int N, realtype t, N_Vector y, N_Vector fy, DlsMat Jac, void *user_data, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3) = &fJac;
  #endif
  
  if (nrhs == 0) {
      printf( "Call function as:\ny = funcName(t, y0[%d], p[%d], u[%d], [reltol, abstol, maxtime])\n", N_STATES, N_PARAMS, N_INPUTS );
      return;
  }
   
  if ( nrhs < numInputArgs ) mexErrMsgTxt( "ERROR: Incorrect number of input arguments\nFormat should be: (t, y0, x, u, [reltol, abstol, max_integration_time], sensitivity*)\n* are optional" );
  
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
      if ( t.length < 3 ) {
          mexErrMsgTxt( "ERROR: Sensitivity analysis is currently only supported for fixed time vector problems. Please supply a time vector longer than 2." );
      } else {
          if ( nlhs > 2 ) {
            if ( nrhs < 7 )
            {
                /* Include sensitivity analysis */
                sensitivity = *mxGetPr( prhs[5] );
            } else {
                 if ( mxGetNumberOfElements( prhs[6] ) < ( N_STATES + N_PARAMS ) * N_STATES )
                     mexErrMsgTxt( "Initial condition vector for sensitivity analysis is of incorrect length!" );
                 else
                     sensitivity = *mxGetPr( prhs[5] );
            }  
          } else mexErrMsgTxt( "Sensitivity analysis requires 3 outputs" );
      }
  }  

  if ( prhs[3] != NULL )
	data.u = mxGetPr( prhs[3] );
  else
	data.u = NULL;
  
  if ( sensitivity == 0 ) {
      /* Set parameter pointer to matlab structure */
      data.p = mxGetPr( prhs[2] );
      /* Copy initial condition to local structure */
      memcpy( y, mxGetPr( prhs[1] ), sizeof( realtype ) * mxGetNumberOfElements( prhs[1] ) );
      y0 = N_VMake_Serial( N_STATES, y ); /* Warning, realtype has to be double for this */
  } else {
      /* Allocate memory for the parameters and initial conditions */
      data.p = malloc( sizeof( realtype ) * ( N_STATES + N_PARAMS ) );
      /* Copy parameters to local structure */
      memcpy( &data.p[0], mxGetPr( prhs[2] ), sizeof( realtype ) * mxGetNumberOfElements( prhs[2] ) );
      /* Copy initial conditions to local structure */
      memcpy( &data.p[N_PARAMS], mxGetPr( prhs[1] ), sizeof( realtype ) * mxGetNumberOfElements( prhs[1] ) );
      /* Set initial condition pointer to appropriate address */
      y0 = N_VMake_Serial( N_STATES, &data.p[N_PARAMS] ); /* Warning, realtype has to be double for this */
  }
  
  /* Set begin time */
  if ( t.length == 1 )
    t0 = 0.0;
  else
    t0 = t.val[0];

  /* Start up CVode */
  #if SOLVER < 10
    cvode_mem     = CVodeCreate( CV_BDF, CV_NEWTON );
  #else
    cvode_mem     = CVodeCreate( CV_ADAMS, CV_FUNCTIONAL );      
  #endif


  /* Initialise CVode */
  if ( CVodeInit( cvode_mem, f, t0, y0 ) != CV_SUCCESS ) {
      N_VDestroy_Serial( y0 );
      mexErrMsgTxt( "ERROR: Failed to initialise CVode" );
  }

  /* Specify tolerances */
  if ( CVodeSStolerances( cvode_mem, tol.val[0], tol.val[1] ) != CV_SUCCESS ) {
      N_VDestroy_Serial( y0 );
      CVodeFree( &cvode_mem );
      mexErrMsgTxt( "ERROR: Failed to set tolerances" );
  }

  CVodeSetMaxStep( cvode_mem, MAX_STEPSIZE );
  CVodeSetMinStep( cvode_mem, MIN_STEPSIZE );
  CVodeSetMaxConvFails( cvode_mem, MAX_CONV_FAIL );
  CVodeSetMaxNumSteps( cvode_mem, MAX_STEPS );
  CVodeSetMaxErrTestFails( cvode_mem, MAX_ERRFAILS );
  CVodeSetMaxTime( cvode_mem, tol.val[2] );
  
  /*  We need to pass our parameters and inputs to the ODE file */
  pData = &data;
  if ( CVodeSetUserData( cvode_mem, pData ) != CV_SUCCESS ) {
      mexErrMsgTxt( "ERROR: Failed passing parameters and initial conditions" );
  }  
  
  #if SOLVER == 1
    /* Attach dense linear solver module */
    if ( CVDense( cvode_mem, N_STATES ) != CV_SUCCESS ) {
          N_VDestroy_Serial( y0 );
          CVodeFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }
  #endif
  #if SOLVER == 2
    /* Use LAPACK solver */
    if ( CVLapackDense( cvode_mem, N_STATES ) != CV_SUCCESS ) {
          N_VDestroy_Serial( y0 );
          CVodeFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );      
    }          
  #endif
          
  #ifdef FJAC
	if ( CVDlsSetDenseJacFn(cvode_mem, fj) != CV_SUCCESS ) {
        N_VDestroy_Serial( y0 );
        CVodeFree( &cvode_mem );              
        mexErrMsgTxt( "Failed to supply analytical Jacobian of RHS" );
    }
  #endif          
  #if SOLVER == 3
    /* Use scaled preconditioned GMRES */
    if ( CVSpgmr( cvode_mem, PREC_BOTH, 0 ) != CV_SUCCESS ) {
          N_VDestroy_Serial( y0 );
          CVodeFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  #if SOLVER == 4
    /* Use preconditioned Bi-CGStab solver */
    if ( CVSpbcg( cvode_mem, PREC_BOTH, 0 ) != CV_SUCCESS ) {
          N_VDestroy_Serial( y0 );
          CVodeFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  #if SOLVER == 5
    /* Use preconditioned TFQMR iterative solver */
    if ( CVSptfqmr( cvode_mem, PREC_BOTH, 0 ) != CV_SUCCESS ) {
          N_VDestroy_Serial( y0 );
          CVodeFree( &cvode_mem );
          mexErrMsgTxt( "ERROR: Failed to attach linear solver module" );
    }          
  #endif
  
/* Current implementation keeps tolerances the same for all vectors
  if ( CVodeSVtolerances( cvode_mem, reltol, abstol ) != CV_SUCCESS ) {
      mexErrMsgTxt( "ERROR: Failed to set SV tolerances" );
  } */
          
  if ( sensitivity == 1 )
  {
      sensitivityBlock          = ( N_STATES + N_PARAMS ) * N_STATES;
      sensitivityBlockSize      = sizeof( double ) * ( N_STATES + N_PARAMS ) * N_STATES;
      
      /* Create an empty list of vectors for the sensitivities */
      yS0 = N_VCloneEmptyVectorArray( N_STATES + N_PARAMS, y0 );
      
      if ( nrhs < 7 ) {
          /* Allocate memory for the sensitivities at the current point */
          sensitivities = malloc( sensitivityBlockSize );
      
          /* Initialise the sensitivities */
          for ( k = 0; k < ( N_STATES + N_PARAMS ) * N_STATES; k++ ) {
                sensitivities[ k ] = 0;
          }

          /* Sensitivity initial conditions should be one on the diagonal for initial condition sensitivities */
          ind = N_STATES * N_PARAMS;
          for ( k = 0; k < N_STATES; k++ ) {
              sensitivities[ ind + k + k * N_STATES ] = 1;
          }
      } else {
          sensitivities = mxGetPr( prhs[6] );
      }

      tols = malloc( ( N_STATES + N_PARAMS ) * sizeof( double ) );
      
      /* Set the pointer to the sensitivity matrix so that CVode can find it */
      for ( k = 0; k < N_STATES + N_PARAMS; k++ ) {
          N_VSetArrayPointer_Serial( &sensitivities[k * N_STATES], yS0[k] );
          tols[ k ] = tol.val[1];
      }

      sParList = malloc( sizeof( int ) * ( N_STATES + N_PARAMS ) );
      for ( k = 0; k < N_PARAMS; k++ ) {
          sParList[k] = k;
        }
      for ( k = N_PARAMS; k < N_PARAMS+N_STATES; k++ ) {
          sParList[k] = k;
        }

      /* Initialise the sensitivity module of CVode */
      #ifdef AJAC
            flag = CVodeSensInit( cvode_mem, N_STATES+N_PARAMS, CV_SIMULTANEOUS, g, yS0 );
      #else
            flag = CVodeSensInit( cvode_mem, N_STATES+N_PARAMS, CV_SIMULTANEOUS, NULL, yS0 );
      #endif

      flag = CVodeSensSStolerances( cvode_mem, tol.val[0], tols );
      flag = CVodeSetSensParams( cvode_mem, data.p, NULL, sParList );

      free( sParList );
      
      if ( flag != CV_SUCCESS ) {
        N_VDestroy_Serial( y0 );
        N_VDestroyVectorArray_Serial( yS0, N_STATES + N_PARAMS );
        free( sensitivities );
        free( data.p );
        free( tols );
        free( cvode_mem );
        mexErrMsgTxt( "ERROR: Failed to set the sensitivity analysis parameters" );
      }     

      /* Allocate memory for the output sensitivities */
      if ( nlhs > 2 ) mxDestroyArray(plhs[2]);
      plhs[2] = mxCreateDoubleMatrix( sensitivityBlock, t.length, mxREAL );
      sensitivityOutputs = mxGetPr( plhs[2] );
  }


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
        flag = CVode( cvode_mem, t.val[1], y0, &tret, CV_ONE_STEP );
        if ( flag < 0 ) handleError( cvode_mem, y0, flag, plhs, nrhs, 0, NULL, NULL, NULL );
      
        /* Check if the memory is still sufficient to store the output */
        if ( ( k + 1 ) > mSize ) {
            /* If we run out of memory, increase the storage size */
            nBlocks ++;
            mSize     = nBlocks * BLOCK_SIZE;
            
            /* We're not done yet so resize the block */
            tOutput = reAllocate2DOutputMemory( tOutput, cvode_mem, y0, plhs[0], 1, mSize );
            yOutput = reAllocate2DOutputMemory( yOutput, cvode_mem, y0, plhs[1], N_STATES, mSize );
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
   
      #ifdef FIXEDRANGE
        /* Added by Ir. C. A. Tiemann to support fixed end time */
        tret 		= tOutput[k-1];
        memcpy( &NV_DATA_S( y0 )[0], &yOutput[p-N_STATES], sizeof( realtype ) * N_STATES );
        flag 		= CVode( cvode_mem, t.val[1], y0, &tret, CV_NORMAL );
        memcpy( &yOutput[p], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );
        tOutput[k] 	= tret;
      #endif
    
      if ( nBlocks > 1 ) {
        printf( "WARNING: Required %d memory reallocations. Consider increasing block size.\n\n", nBlocks );
      }
      
      /* After we are done simulating, we tighten the memory block to the true size */
      tOutput = reAllocate2DOutputMemory( tOutput, cvode_mem, y0, plhs[0], 1, k + 1 );
      yOutput = reAllocate2DOutputMemory( yOutput, cvode_mem, y0, plhs[1], N_STATES, k + 1 );      
      
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
          flag = CVode( cvode_mem, t.val[0], y0, &tret, CV_NORMAL );
          if ( flag < 0 ) handleError( cvode_mem, y0, flag, plhs, nrhs, 0, NULL, NULL, NULL );

          memcpy( &yOutput[0], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );
          tOutput[0] = tret;
      } else {

          /* Steps were specified --> Static memory allocation (faster) */
	  if ( nlhs > 0 ) mxDestroyArray(plhs[0]);
          plhs[0]       = mxCreateDoubleMatrix( 1, t.length, mxREAL );
          tOutput       = mxGetPr(plhs[0]);
          tOutput[0]    = t.val[0];
          tret          = t.val[0];

	  if ( nlhs > 1 ) mxDestroyArray(plhs[1]);

          plhs[1]       = mxCreateDoubleMatrix( N_STATES, t.length, mxREAL );
          yOutput       = mxGetPr(plhs[1]);
        
          memcpy( &yOutput[0], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );

          if ( sensitivity == 1 ) {
                memcpy( &sensitivityOutputs[ 0 ], sensitivities, sensitivityBlockSize );
          }

          /* Fixed steps were specified */
          p = N_STATES;
          q = sensitivityBlock;

          for ( k = 1; k < t.length; k++ ) {
              flag = CVode( cvode_mem, t.val[k], y0, &tret, CV_NORMAL );
              if ( flag < 0 ) handleError( cvode_mem, y0, flag, plhs, nrhs, sensitivity, yS0, sensitivities, &data );
              /* Fetch the output */
              memcpy( &yOutput[p], &NV_DATA_S( y0 )[0], sizeof( realtype ) * N_STATES );
              p = p + N_STATES;
              tOutput[k] = t.val[k];
              if ( sensitivity == 1 ) {
                  flag = CVodeGetSens(cvode_mem, &tret, yS0);
                  if ( flag < 0 )
                      handleError( cvode_mem, y0, flag, plhs, nrhs, sensitivity, yS0, sensitivities, &data );
                  else {  
                    memcpy( &sensitivityOutputs[ q ], sensitivities, sensitivityBlockSize );
                    q = q + sensitivityBlock;  
                  }
              }

              time( &tEnd );
              if ( difftime( tEnd, tStart ) > tol.val[2] ) {
                printf( "WARNING: Simulation time exceeded! Aborting simulation", t.val[k] );
                tOutput = reAllocate2DOutputMemory( tOutput, cvode_mem, y0, plhs[0], 1, k );
                yOutput = reAllocate2DOutputMemory( yOutput, cvode_mem, y0, plhs[1], N_STATES, k );            
                break;
              }
          }
      }
  }  
  N_VDestroy_Serial( y0 );

  /* Free CVode memory */
  CVodeFree( &cvode_mem );
  
  if ( sensitivity == 1 ) {
      free( data.p );
      free( tols );
      if ( nrhs < 7 ) free( sensitivities );
      N_VDestroyVectorArray_Serial( yS0, N_STATES + N_PARAMS );
  }
  
  /* If we desire only one output, we probably meant the solution array
     since it is pretty pointless to output the time array */
  if ( nlhs == 1 ) {
      mxDestroyArray( plhs[0] );
      plhs[0] = plhs[1];
  }   
    
}



