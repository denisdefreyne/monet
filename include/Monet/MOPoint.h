#ifndef __MONET_MOPOINT_H__
#define __MONET_MOPOINT_H__

#include <Monet/Common.h>

typedef struct _MOPoint {
	double x;
	double y;
} MOPoint;

MOPoint MOPointMake(double aX, double aY);

#endif
