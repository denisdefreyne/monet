#import <Monet/MOImage.h>
#import <Monet/MOSize.h>
#import <Monet/MOPoint.h>

typedef struct _MOTiledImage MOTiledImage;

MOTiledImage *MOTiledImageCreateFromFile(char *aFilename, MOSize aTileSize);

MOSize MOTiledImageGetTileSize(MOTiledImage *aTiledImage);
MOImage *MOTiledImageAsImage(MOTiledImage *aTiledImage);

void MOTiledImageDrawTileAtPoint(MOTiledImage *aTiledImage, MOPoint aTilePoint, MOPoint aPoint);
