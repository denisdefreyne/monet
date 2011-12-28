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
	aBezierCurve->a = a;
	aBezierCurve->b = b;
	aBezierCurve->c = c;
	aBezierCurve->d = d;
}

double _MOBezierCurveAtDelta1D(double a, double b, double c, double d, double t)
{
    double s = 1 - t;

    double ab = a*s + b*t;
    double bc = b*s + c*t;
    double cd = c*s + d*t;

    double abc = ab*s + bc*t;
    double bcd = bc*s + cd*t;

    return abc*s + bcd*t;
}

MOPoint MOBezierCurveAtDelta(MOBezierCurve *aBezierCurve, double aDelta)
{
	MOBezierCurve *c = aBezierCurve;
	return MOPointMake(
		_MOBezierCurveAtDelta1D(c->a.x, c->b.x, c->c.x, c->d.x, aDelta),
		_MOBezierCurveAtDelta1D(c->a.y, c->b.y, c->c.y, c->d.y, aDelta));
}
