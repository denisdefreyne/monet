#import <Foundation/Foundation.h>

typedef struct _MOPoint {
	SInt16	x;
	SInt16	y;
} MOPoint;

MOPoint MOMakePoint(SInt16 aX, SInt16 aY);