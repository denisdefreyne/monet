#import <Monet/MOPoint.h>

MOPoint MOPointMake(int16_t aX, int16_t aY)
{
	MOPoint point;

	point.x = aX;
	point.y = aY;

	return point;
}
