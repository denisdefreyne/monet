#include <Monet/MOLineSegmentArray.h>

#include <Monet/Common.h>

#include <Monet/MOPoint.h>

COClass MOLineSegmentArrayClass = {
	.size       = sizeof (MOLineSegmentArray),
	.superclass = NULL,
	.destructor = NULL
};

static void _MOLineSegmentArrayDestroy(void *aSelf)
{
	MOLineSegmentArray *self = aSelf;

	if (self->isCopied)
		free(self->points);
	free(self->lineSegmentLengths);
}

void MOLineSegmentArrayInit(MOLineSegmentArray *self, MOPoint *aPoints, size_t aCount)
{
	// Copy points
	MOPoint *points = malloc(aCount * sizeof (MOPoint));
	memcpy(points, aPoints, aCount * sizeof (MOPoint));

	MOLineSegmentArrayInitNoCopy(self, points, aCount);

	self->isCopied = true;
}

void MOLineSegmentArrayInitNoCopy(MOLineSegmentArray *self, MOPoint *aPoints, size_t aCount)
{
	self->count = aCount;
	self->points = aPoints;

	// Calculate lengths
	self->totalLength = 0.0;
	self->lineSegmentLengths = malloc(aCount * sizeof (float));
	for (int i = 0; i < aCount-1; ++i)
	{
		float lineSegmentLength = MOPointDistanceTo(self->points[i], self->points[i+1]);
		self->lineSegmentLengths[i] = lineSegmentLength;
		self->totalLength += lineSegmentLength;
	}

	self->isCopied = false;
}

MOPoint MOLineSegmentArrayGetPointAtDelta(MOLineSegmentArray *self, float aDelta, float *aoRelativeDelta)
{
	if (aDelta < 0.0)
		return self->points[0];
	else if (aDelta > 1.0)
		return self->points[self->count-1];

	float desiredDistance = aDelta * self->totalLength;

	float distanceTravelled = 0.0;
	for (int i = 0; i < self->count-1; ++i)
	{
		float currentLineSegmentLength = self->lineSegmentLengths[i];
		float nextDistanceTravelled = distanceTravelled + currentLineSegmentLength;

		// Evaluate
		if (desiredDistance < nextDistanceTravelled)
		{
			float fraction = (desiredDistance - distanceTravelled) / currentLineSegmentLength;
			MOPoint prevPoint = self->points[i];
			MOPoint nextPoint = self->points[i+1];
			if (aoRelativeDelta)
				*aoRelativeDelta = ((float)i + fraction) / ((float)self->count-1.0);
			return MOPointMake(
				prevPoint.x + (nextPoint.x - prevPoint.x) * fraction,
				prevPoint.y + (nextPoint.y - prevPoint.y) * fraction);
		}

		// Go to next
		distanceTravelled = nextDistanceTravelled;
	}

	return self->points[self->count-1];
}
