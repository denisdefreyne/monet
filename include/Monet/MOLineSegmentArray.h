#ifndef __MONET_MOLINESEGMENTARRAY_H__
#define __MONET_MOLINESEGMENTARRAY_H__

#include <Monet/Common.h>

extern COClass MOLineSegmentArrayClass;

typedef struct _MOLineSegmentArray MOLineSegmentArray;

#include <Monet/MOPoint.h>
#include <GLMath/GLMath.h>

struct _MOLineSegmentArray
{
	COGuts guts;

	size_t  count;
	MOPoint *points;
	bool    isCopied;

	float   *lineSegmentLengths;
	float   totalLength;
};

void MOLineSegmentArrayInit(MOLineSegmentArray *aLineSegmentArray, MOPoint *aPoints, size_t aCount);
void MOLineSegmentArrayInitNoCopy(MOLineSegmentArray *aLineSegmentArray, MOPoint *aPoints, size_t aCount);

MOPoint MOLineSegmentArrayGetPointAtDelta(MOLineSegmentArray *aLineSegmentArray, float aDelta);

#endif
