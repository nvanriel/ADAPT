
#include "jac.h"
#include "objfn.h"
//#include "time.h"
//%#include "string.h"

int sensitivities;

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  sensitivities = 0;
  
  if (nrhs == 0) {
      //printf( "Call function as:\ny = funcName(x0)\n", N_STATES, N_PARAMS, N_INPUTS );
      return;
  }
   
  if ( nrhs < 4 ) mexErrMsgTxt( "ERROR: Incorrect number of input arguments\nFormat should be: (x, p, data, u, S*)\n* are optional" );
  
  /* Check input dimensions */
  if ( ( mxGetM( prhs[0] ) != N_STATES ) && ( mxGetN( prhs[0] ) != N_TIME ) )
  {
    printf( "ERROR: State matrix has incorrect dimensions! Expected %d by %d, found %d by %d", N_STATES, N_TIME, mxGetM( prhs[0] ), mxGetN( prhs[0] ) );
    mexErrMsgTxt( "" );
  }

  if ( mxGetN( prhs[1] ) != ( N_PARS + N_OBSPARS + N_ICPARS ) )
  {
    printf( "ERROR: Parameter vector has incorrect dimensions! Expected %d, found %d", N_PARS+N_OBSPARS+N_ICPARS, mxGetN( prhs[1] ) );
    mexErrMsgTxt( "" );
  }

  if ( mxGetN( prhs[2] ) != ( N_DATA ) )
  {
    printf( "ERROR: Data vector has incorrect dimensions! Expected %d, found %d", N_DATA, mxGetN( prhs[2] ) );
    mexErrMsgTxt( "" );
  }
  
  if ( mxGetN( prhs[3] ) != ( N_INPUT ) )
  {
    printf( "ERROR: Input vector has incorrect dimensions! Expected %d, found %d", N_INPUT, mxGetN( prhs[3] ) );
    mexErrMsgTxt( "" );
  }
  
  if ( nlhs > 1 )
  {
      if ( nrhs < 5 ) mexErrMsgTxt( "ERROR: Sensitivity outputs require a valid sensitivity matrix" ); 
      if ( mxGetM( prhs[4] ) != ( N_STATES * ( N_STATES + N_PARS ) ) && ( mxGetN( prhs[4] ) != N_TIME ) )
      {
            printf( "ERROR: Sensitivity matrix has incorrect dimensions! Expected %d by %d, found %d by %d", N_STATES * ( N_STATES + N_PARS ), N_TIME, mxGetM( prhs[4] ), mxGetN( prhs[4] ) );
            mexErrMsgTxt( "" );          
      } else {
        #ifdef CJAC
            sensitivities = 1;
        #endif
      }
  }
  
  plhs[0] = mxCreateDoubleMatrix( N_OBS, 1, mxREAL );
  
  objectiveFn( mxGetPr( plhs[0] ), mxGetPr( prhs[0] ), mxGetPr( prhs[1] ), mxGetPr( prhs[2] ), mxGetPr( prhs[3] ) );
  
  #ifdef CJAC
      if ( sensitivities == 1 )
      {
          plhs[1] = mxCreateDoubleMatrix( N_OBS, N_OBSPARS + N_PARS + N_ICPARS, mxREAL );
          jacobian( mxGetPr( plhs[1] ), mxGetPr( prhs[0] ), mxGetPr( prhs[1] ), mxGetPr( prhs[2] ), mxGetPr( prhs[3] ), mxGetPr( prhs[4] ) );
      }
  #endif
  
}



