#ifndef __MONET_MOPOINT_H__
#define __MONET_MOPOINT_H__

#include <Monet/Common.h>

typedef vec2_t MOPoint;

static inline MOPoint MOPointMake(float aX, float aY)
{
	return vec2_create(aX, aY);
}

#endif
