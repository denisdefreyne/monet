#include <Monet/MOTiledImage.h>

#include <Monet/Common.h>

#include <Monet/MOGraphicsContext.h>
#include <Monet/Private.h>

void _MOTiledImageDestroy(void *aTiledImage);

COClass MOTiledImageClass = {
	.superclass = NULL,
	.destructor = NULL
};

MOTiledImage *MOTiledImageCreateFromFile(char *aFilename, MOSize aTileSize)
{
	// Create tiled image
	MOTiledImage *tiledImage = calloc(1, sizeof (MOTiledImage));
	COInitialize(tiledImage, &MOTiledImageClass);

	// Initialize
	tiledImage->tileSize = aTileSize;
	tiledImage->image = MOImageCreateFromFile(aFilename);

	return tiledImage;
}

void _MOTiledImageDestroy(void *aTiledImage)
{
	MOTiledImage *tiledImage = (MOTiledImage *)aTiledImage;

	CORelease(tiledImage->image);
	CORelease(tiledImage);
}

MOSize MOTiledImageGetTileSize(MOTiledImage *aTiledImage)
{
	return aTiledImage->tileSize;
}

MOImage *MOTiledImageAsImage(MOTiledImage *aTiledImage)
{
	return aTiledImage->image;
}

void MOTiledImageDrawTileAtPoint(MOTiledImage *aTiledImage, MOPoint aTilePoint, MOPoint aPoint)
{
	// Get absolute destination
	MORect dstRect = MOGraphicsContext_getCurrentRect();
	MOPoint dstPoint = MOPointMake(dstRect.x + aPoint.x, dstRect.y + aPoint.y);

	// Get tile origin
	MOPoint tileOrigin;
	tileOrigin.x = aTilePoint.x * aTiledImage->tileSize.w;
	tileOrigin.y = aTilePoint.y * aTiledImage->tileSize.h;

	// TODO [OpenGL] translate using matrixes

	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, aTiledImage->image->textureName);
	glBegin(GL_QUADS);
	{
		// bottom left
		glTexCoord2i(tileOrigin.x,                              tileOrigin.y);
		glVertex2i(  dstPoint.x,                                dstPoint.y + aTiledImage->tileSize.h);

		// bottom right
		glTexCoord2i(tileOrigin.x + aTiledImage->tileSize.w,    tileOrigin.y);
		glVertex2i(  dstPoint.x + aTiledImage->tileSize.w,      dstPoint.y + aTiledImage->tileSize.h);

		// top right
		glTexCoord2i(tileOrigin.x + aTiledImage->tileSize.w,    tileOrigin.y + aTiledImage->tileSize.h);
		glVertex2i(  dstPoint.x + aTiledImage->tileSize.w,      dstPoint.y);

		// top left
		glTexCoord2i(tileOrigin.x,                              tileOrigin.y + aTiledImage->tileSize.h);
		glVertex2i(  dstPoint.x,                                dstPoint.y);
	}
	glEnd();
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}
