#import <Monet/MOTiledImage.h>

#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

@implementation MOTiledImage

- (id)initWithContentsOfFile:(NSString *)aFilename tileSize:(MOSize)aTileSize
{
	if(self = [super initWithContentsOfFile:aFilename])
	{
		tileSize = aTileSize;
	}

	return self;
}

#pragma mark -

- (MOSize)tileSize
{
	return tileSize;
}

#pragma mark -

- (void)drawTile:(MOPoint)aTilePoint atPoint:(MOPoint)aPoint
{
	// Get absolute destination
	MORect dstRect = [[MOGraphicsContext currentContext] rect];
	MOPoint dstPoint = MOMakePoint(dstRect.x + aPoint.x, dstRect.y + aPoint.y);

	// Get tile origin
	MOPoint tileOrigin;
	tileOrigin.x = aTilePoint.x * tileSize.w;
	tileOrigin.y = aTilePoint.y * tileSize.h;

	// TODO [OpenGL] translate using matrixes

	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, textureName);
	glBegin(GL_QUADS);
	{
		// FIXME [OpenGL] allow drawing into textures

		// bottom left
		glTexCoord2i(	tileOrigin.x,				tileOrigin.y);
		glVertex2i(		dstPoint.x,					dstPoint.y);

		// bottom right
		glTexCoord2i(	tileOrigin.x + tileSize.w,	tileOrigin.y);
		glVertex2i(		dstPoint.x + tileSize.w,	dstPoint.y);

		// top right
		glTexCoord2i(	tileOrigin.x + tileSize.w,	tileOrigin.y + tileSize.h);
		glVertex2i(		dstPoint.x + tileSize.w,	dstPoint.y + tileSize.h);

		// top left
		glTexCoord2i(	tileOrigin.x,				tileOrigin.y + tileSize.h);
		glVertex2i(		dstPoint.x,					dstPoint.y + tileSize.h);
	}
	glEnd();
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}

@end
