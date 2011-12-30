#ifndef __MONET_MORECT_H__
#define __MONET_MORECT_H__

#include <Monet/Common.h>

typedef rect_t MORect;

#include <Monet/MOColor.h>
#include <Monet/MOPoint.h>

static inline MORect MORectMake(float aX, float aY, float aW, float aH)
{
	return rect_createWithSize(vec2_create(aX, aY), vec2_create(aW, aH));
}

void MORectFill(MORect aRect, MOColor aColor);
void MORectStroke(MORect aRect, MOColor aColor);

static inline bool MORectContainsPoint(MORect aRect, MOPoint aPoint)
{
	return rect_containsPoint(aRect, aPoint);
}

static inline bool MORectIntersectsRect(MORect aRect1, MORect aRect2)
{
	return rect_intersects(aRect1, aRect2);
}

#endif
