#import <Foundation/Foundation.h>

#import <Monet/MOImage.h>
#import <Monet/MOSize.h>
#import <Monet/MOPoint.h>

@interface MOTiledImage : MOImage
{
	struct MOTiledImageData *tiledImageData;
}

- (id)initWithContentsOfFile:(NSString *)aFilename tileSize:(MOSize)aTileSize;

- (MOSize)tileSize;

- (void)drawTile:(MOPoint)aTilePoint atPoint:(MOPoint)aPoint;

@end
