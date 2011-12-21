#ifndef __MONET_MOIMAGE_H__
#define __MONET_MOIMAGE_H__

#include <Monet/MOPoint.h>
#include <Monet/MORect.h>
#include <Monet/MOSize.h>

typedef struct _MOImage MOImage;

MOImage *MOImageCreateFromFile(char *aFilename);
MOImage *MOImageCreateWithSize(MOSize aSize);

void MOImageLockFocus(MOImage *aImage);
void MOImageUnlockFocus(MOImage *aImage);

MORect MOImageGetBounds(MOImage *aImage);

// FIXME allow drawing into a MOImage instead
void MOImageTakeFromOnScreenRect(MOImage *aImage, MORect aRect);

void MOImageDrawAtPoint(MOImage *aImage, MOPoint aPoint);

#endif
