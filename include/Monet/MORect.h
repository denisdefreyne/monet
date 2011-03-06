#import <Foundation/Foundation.h>
#import <stdint.h>

#import <Monet/MOPoint.h>

@class MOColor;

typedef struct _MORect {
	int16_t x, y;
	uint16_t w, h;
} MORect;

MORect MORectMake(int16_t aX, int16_t aY, uint16_t aW, uint16_t aH);

void MOFillRect(MORect aRect, MOColor *aColor);
void MOStrokeRect(MORect aRect, MOColor *aColor);

BOOL MORectContainsPoint(MORect aRect, MOPoint aPoint);
BOOL MORectIntersectsRect(MORect aRect1, MORect aRect2);
