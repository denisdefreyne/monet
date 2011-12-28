#ifndef __MONET_MOBEZIERCURVE_H__
#define __MONET_MOBEZIERCURVE_H__

#include <Monet/Common.h>

extern COClass MOBezierCurveClass;

typedef struct _MOBezierCurve MOBezierCurve;

#include <Monet/MOPoint.h>

struct _MOBezierCurve
{
	COGuts guts;
	MOPoint a, b, c, d;
};

void MOBezierCurveInit(MOBezierCurve *aBezierCurve, MOPoint a, MOPoint b, MOPoint c, MOPoint d);

MOPoint MOBezierCurveAtDelta(MOBezierCurve *aBezierCurve, double aDelta);

#endif
