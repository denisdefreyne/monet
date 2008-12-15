#import <Foundation/Foundation.h>

#import <Monet/Types.h>

#import <Monet/MOColor.h>
#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

typedef struct _MORect {
	SInt16 x, y;
	UInt16 w, h;
} MORect;

MORect MORectMake(SInt16 aX, SInt16 aY, UInt16 aW, UInt16 aH);

void MOFillRect(MORect aRect, MOColor aColor);
void MOStrokeRect(MORect aRect, MOColor aColor);

BOOL MORectContainsPoint(MORect aRect, MOPoint aPoint);
BOOL MORectIntersectsRect(MORect aRect1, MORect aRect2);
