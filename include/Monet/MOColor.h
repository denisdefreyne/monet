#ifndef __MONET_MOCOLOR_H__
#define __MONET_MOCOLOR_H__

#include <Monet/Common.h>

typedef vec4_t MOColor;

static inline MOColor MOColorMakeRGB(double aRed, double aGreen, double aBlue)
{
	return vec4_create(aRed, aGreen, aBlue, 0.0);
}

static inline MOColor MOColorMakeRGBA(double aRed, double aGreen, double aBlue, double aAlpha)
{
	return vec4_create(aRed, aGreen, aBlue, aAlpha);
}

#endif
