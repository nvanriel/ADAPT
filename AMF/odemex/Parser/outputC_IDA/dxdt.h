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

#ifndef _DXDT_H_
#define _DXDT_H_

#define realtype double

int rhs( realtype t, N_Vector y, N_Vector ydot, N_Vector resid, void *f_data );


#endif
