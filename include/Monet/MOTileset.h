#import <Monet/MOImage.h>
#import <Monet/MOSize.h>
#import <Monet/MOPoint.h>

@interface MOTileset : MOImage
{
	MOSize tileSize;
}

- (id)initWithContentsOfFile:(NSString *)aFilename tileSize:(MOSize)aTileSize;

- (MOSize)tileSize;

- (void)drawTile:(MOPoint)aTilePoint atPoint:(MOPoint)aPoint;

@end