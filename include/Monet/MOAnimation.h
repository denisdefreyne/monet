#ifndef __MONET_MOANIMATION_H__
#define __MONET_MOANIMATION_H__

#include <Monet/Common.h>

extern COClass MOAnimationClass;

typedef struct _MOAnimation MOAnimation;

#include <Monet/MOPoint.h>

struct _MOAnimation
{
	COGuts guts;

	double durationInSeconds;
	double elapsedSeconds;
	bool   isLooped;
	// TODO add type (linear, ease in, ease out, ease in/out, sinusoidal, …)
};

// TODO MOAnimationReset()
// TODO MOAnimationIsComplete()
// TODO animation completion callback

void MOAnimationInit(MOAnimation *aAnimation, double aDurationInSeconds);

void MOAnimationSetIsLooped(MOAnimation *aAnimation, bool aIsLooped);

void MOAnimationTick(MOAnimation *aAnimation, double aSeconds);
double MOAnimationGetProgress(MOAnimation *aAnimation);

#endif
