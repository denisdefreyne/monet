#ifndef __MONET_MOTILEDIMAGE_H__
#define __MONET_MOTILEDIMAGE_H__

typedef struct _MOTiledImage MOTiledImage;

#include <Monet/MOImage.h>
#include <Monet/MOSize.h>
#include <Monet/MOPoint.h>

MOTiledImage *MOTiledImageCreateFromFile(char *aFilename, MOSize aTileSize);

MOSize MOTiledImageGetTileSize(MOTiledImage *aTiledImage);
MOImage *MOTiledImageAsImage(MOTiledImage *aTiledImage);

void MOTiledImageDrawTileAtPoint(MOTiledImage *aTiledImage, MOPoint aTilePoint, MOPoint aPoint);

#endif
