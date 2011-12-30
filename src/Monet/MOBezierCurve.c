#include <Monet/MOBezierCurve.h>

#include <Monet/Common.h>

#include <Monet/MOPoint.h>

COClass MOBezierCurveClass = {
	.size       = sizeof (MOBezierCurve),
	.superclass = NULL,
	.destructor = NULL
};

void MOBezierCurveInit(MOBezierCurve *aBezierCurve, MOPoint a, MOPoint b, MOPoint c, MOPoint d)
{
	aBezierCurve->glmBezierCurve = bezier_create(
		vec3_create(a.x, a.y, 0.0),
		vec3_create(b.x, b.y, 0.0),
		vec3_create(c.x, c.y, 0.0),
		vec3_create(d.x, d.y, 0.0));
}

MOPoint MOBezierCurveGetPointAtDelta(MOBezierCurve *aBezierCurve, float aDelta)
{
	vec3_t res = bezier_getPoint(aBezierCurve->glmBezierCurve, aDelta);
	return vec2_create(res.x, res.y);
}

MOPoint MOBezierCurveGetTangentAtDelta(MOBezierCurve *aBezierCurve, float aDelta)
{
	vec3_t res = bezier_firstDerivative(aBezierCurve->glmBezierCurve, aDelta);
	return vec2_create(res.x, res.y);
}

MOPoint MOBezierCurveGetOffsetPointAtDelta(MOBezierCurve *aBezierCurve, float aOffset, float aDelta)
{
	vec3_t res = bezier_getPointWithOffset(aBezierCurve->glmBezierCurve, aDelta, vec3_create(aOffset, aOffset, 0.0));
	return vec2_create(res.x, res.y);
}
