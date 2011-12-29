#include <Monet/MOAnimation.h>

#include <Monet/Common.h>

COClass MOAnimationClass = {
	.size       = sizeof (MOAnimation),
	.superclass = NULL,
	.destructor = NULL
};

void MOAnimationInit(MOAnimation *aAnimation, double aDurationInSeconds)
{
	aAnimation->durationInSeconds = aDurationInSeconds;
	aAnimation->elapsedSeconds    = 0.0;
	aAnimation->isLooped          = false;
}

void MOAnimationSetIsLooped(MOAnimation *aAnimation, bool aIsLooped)
{
	aAnimation->isLooped = aIsLooped;
}

void MOAnimationTick(MOAnimation *aAnimation, double aSeconds)
{
	aAnimation->elapsedSeconds += aSeconds;

	if (aAnimation->isLooped)
	{
		while (aAnimation->elapsedSeconds > aAnimation->durationInSeconds)
			aAnimation->elapsedSeconds -= aAnimation->durationInSeconds;
	}
}

double MOAnimationGetProgress(MOAnimation *aAnimation)
{
	double unclampedProgress = aAnimation->elapsedSeconds / aAnimation->durationInSeconds;

	if (unclampedProgress > 1.0)
		return 1.0;
	else
		return unclampedProgress;
}
