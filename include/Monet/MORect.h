#ifndef __MONET_MORECT_H__
#define __MONET_MORECT_H__

#include <SeaBase/Types.h>

struct _MORect {
	int16_t x, y;
	uint16_t w, h;
};
typedef struct _MORect MORect;

#include <Monet/MOColor.h>
#include <Monet/MOPoint.h>

MORect MORectMake(int16_t aX, int16_t aY, uint16_t aW, uint16_t aH);

void MORectFill(MORect aRect, MOColor aColor);
void MORectStroke(MORect aRect, MOColor aColor);

bool MORectContainsPoint(MORect aRect, MOPoint aPoint);
bool MORectIntersectsRect(MORect aRect1, MORect aRect2);

#endif
