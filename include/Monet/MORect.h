#import <Foundation/Foundation.h>

#import <Monet/MOColor.h>
#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

typedef struct _MORect {
	MOPoint	origin;
	MOSize	size;
} MORect;

MORect MOMakeRect(SInt16 aX, SInt16 aY, UInt16 aWidth, UInt16 aHeight);

void MOFillRect(MORect aRect, MOColor aColor);
