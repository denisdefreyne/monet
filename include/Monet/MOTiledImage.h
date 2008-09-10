#import <Foundation/Foundation.h>

#import <Monet/MOImage.h>
#import <Monet/MOSize.h>
#import <Monet/MOPoint.h>

@interface MOTiledImage : MOImage
{
	MOSize tileSize;
}

- (id)initWithContentsOfFile:(NSString *)aFilename tileSize:(MOSize)aTileSize;
- (id)initWithContentsOfFile:(NSString *)aFilename transparencyType:(MOTransparencyType)aTransparencytype tileSize:(MOSize)aTileSize;

- (MOSize)tileSize;

- (void)drawTile:(MOPoint)aTilePoint atPoint:(MOPoint)aPoint;

@end
