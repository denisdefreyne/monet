#ifndef __MONET_MOBEZIERCURVE_H__
#define __MONET_MOBEZIERCURVE_H__

#include <Monet/Common.h>

extern COClass MOBezierCurveClass;

typedef struct _MOBezierCurve MOBezierCurve;

#include <Monet/MOPoint.h>
#include <GLMath/GLMath.h>

struct _MOBezierCurve
{
	COGuts guts;
	bezier_t glmBezierCurve;
};

void MOBezierCurveInit(MOBezierCurve *aBezierCurve, MOPoint a, MOPoint b, MOPoint c, MOPoint d);

MOPoint MOBezierCurveGetPointAtDelta(MOBezierCurve *aBezierCurve, float aDelta);
MOPoint MOBezierCurveGetTangentAtDelta(MOBezierCurve *aBezierCurve, float aDelta);
MOPoint MOBezierCurveGetOffsetPointAtDelta(MOBezierCurve *aBezierCurve, float aOffset, float aDelta);

#endif
