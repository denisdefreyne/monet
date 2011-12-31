#ifndef __MONET_MOPOINT_H__
#define __MONET_MOPOINT_H__

#include <Monet/Common.h>

typedef vec2_t MOPoint;

static inline MOPoint MOPointMake(float aX, float aY)
{
	return vec2_create(aX, aY);
}

static inline MOPoint MOPointAdd(MOPoint aPoint1, MOPoint aPoint2)
{
	return vec2_add(aPoint1, aPoint2);
}

static inline MOPoint MOPointSubtract(MOPoint aPoint1, MOPoint aPoint2)
{
	return vec2_sub(aPoint1, aPoint2);
}

static inline float MOPointDistanceTo(MOPoint aPoint1, MOPoint aPoint2)
{
	return vec2_dist(aPoint1, aPoint2);
}

#endif
