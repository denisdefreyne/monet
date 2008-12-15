#import <Monet/MOTiledImage.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

struct MOTiledImageData
{
	MOSize tileSize;
};

@implementation MOTiledImage

- (id)initWithContentsOfFile:(NSString *)aFilename tileSize:(MOSize)aTileSize
{
	if(self = [super initWithContentsOfFile:aFilename])
	{
		tiledImageData = calloc(1, sizeof (struct MOTiledImageData));

		tiledImageData->tileSize = aTileSize;
	}

	return self;
}

#pragma mark -

- (MOSize)tileSize
{
	return tiledImageData->tileSize;
}

#pragma mark -

- (void)drawTile:(MOPoint)aTilePoint atPoint:(MOPoint)aPoint
{
	// Get absolute destination
	MORect dstRect = [[MOGraphicsContext currentContext] rect];
	MOPoint dstPoint = MOPointMake(dstRect.x + aPoint.x, dstRect.y + aPoint.y);

	// Get tile origin
	MOPoint tileOrigin;
	tileOrigin.x = aTilePoint.x * tiledImageData->tileSize.w;
	tileOrigin.y = aTilePoint.y * tiledImageData->tileSize.h;

	// TODO [OpenGL] translate using matrixes

	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, imageData->textureName);
	glBegin(GL_QUADS);
	{
		// bottom left
		glTexCoord2i(	tileOrigin.x,								tileOrigin.y);
		glVertex2i(		dstPoint.x,									dstPoint.y + tiledImageData->tileSize.h);

		// bottom right
		glTexCoord2i(	tileOrigin.x + tiledImageData->tileSize.w,	tileOrigin.y);
		glVertex2i(		dstPoint.x + tiledImageData->tileSize.w,	dstPoint.y + tiledImageData->tileSize.h);

		// top right
		glTexCoord2i(	tileOrigin.x + tiledImageData->tileSize.w,	tileOrigin.y + tiledImageData->tileSize.h);
		glVertex2i(		dstPoint.x + tiledImageData->tileSize.w,	dstPoint.y);

		// top left
		glTexCoord2i(	tileOrigin.x,								tileOrigin.y + tiledImageData->tileSize.h);
		glVertex2i(		dstPoint.x,									dstPoint.y);
	}
	glEnd();
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}

@end
