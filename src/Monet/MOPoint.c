#include <Monet/MOPoint.h>

MOPoint MOPointMake(double aX, double aY)
{
	MOPoint point;

	point.x = aX;
	point.y = aY;

	return point;
}
