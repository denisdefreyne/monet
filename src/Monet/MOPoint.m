#import <Monet/MOPoint.h>

MOPoint MOMakePoint(SInt16 aX, SInt16 aY)
{
	MOPoint point;

	point.x = aX;
	point.y = aY;

	return point;
}
