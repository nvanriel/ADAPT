#include "../dxdt.h"



int rhs( realtype t, N_Vector y, N_Vector ydot, void *f_data ) {

	struct mData *data = ( struct mData * ) f_data;

	realtype BW , Gb , Glucose , Gtot , Insulin , Ra , Ra_g , Ra_mg , SI , V , X , dGdt , dxdt , p1 , p2 , p3 , rG1a , rG1b , rG2 , rG3 , rX1 , rX2 , ra0 , ra1 , ra2 , ra3 , ra4 , ra5 , ra6 ;

	realtype *stateVars;
	realtype *ydots;

	stateVars = NV_DATA_S(y);
	ydots = NV_DATA_S(ydot);

	
	Insulin =interpolate( &data->u[9], &data->u[0],9,t,1);
	Ra =interpolate( &data->u[25], &data->u[18],7,t,1);
	
	Gb =126.1274;
	Gtot =40;
	V =1.7;
	BW =127;
	
	Glucose =stateVars[0];
	X =stateVars[1];
	
	p1 =data->p[0];
	p2 =data->p[1];
	p3 =data->p[2];
	ra0 =data->p[3];
	ra1 =data->p[4];
	ra2 =data->p[5];
	ra3 =data->p[6];
	ra4 =data->p[7];
	ra5 =data->p[8];
	ra6 =data->p[9];
	
	rG1a = -(p1) *Glucose;
	rG1b = -(X) *Glucose;
	rG2 =p1 *Gb;
	rG3 =Ra/V;
	rX1 = -p2 *X;
	rX2 =p3 *Insulin;
	dGdt =rG1a +rG1b +rG2 +rG3;
	Ra_mg =Ra *BW;
	Ra_g =Ra_mg /1000;
	SI =p3/p2;
	
	ydots[0] =dGdt;
	ydots[1] =rX1 +rX2;
	
	


	#ifdef NON_NEGATIVE
		return 0;
	#else
		return 0;
	#endif

};

