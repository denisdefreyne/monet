#include <Monet/MOImage.h>

#include <Monet/Common.h>

#include <Monet/MOGraphicsContext.h>
#include <Monet/Private.h>

void _MOImageDestroy(void *aImage);

COClass MOImageClass = {
	.superclass = NULL,
	.destructor = &_MOImageDestroy
};

MOImage *MOImageCreateFromFile(char *aFilename)
{
	// Create image
	MOImage *image = calloc(1, sizeof (MOImage));
	COInitialize(image, &MOImageClass);

	// Load file
	SDL_Surface *surface = IMG_Load(aFilename);
	if (!surface)
	{
		fprintf(stderr, "IMG_Load failed (%s)\n", SDL_GetError());
		exit(1);
	}

	// Create texture
	glGenTextures(1, &image->textureName);
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, image->textureName);
	glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

	// Get number of colors and texture format
	GLint  numberOfColors = surface->format->BytesPerPixel;
	GLenum textureFormat;
	if (numberOfColors == 4)
	{
		if (surface->format->Rmask == 0x000000ff)
			textureFormat = GL_RGBA;
		else
			textureFormat = GL_BGRA;
	}
	else if (numberOfColors == 3)
	{
		if (surface->format->Rmask == 0x000000ff)
			textureFormat = GL_RGB;
		else
			textureFormat = GL_BGR;
	}
	else
	{
		// TODO handle gracefully
		fprintf(stderr, "glTexImage2D preparation failed: image is not in truecolor (filename = %s)\n", aFilename);
		exit(1);
	}

	// Set size
	image->size = MOSizeMake(surface->w, surface->h);

	// Fill texture
	SDL_LockSurface(surface);
	glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, image->size.w, image->size.h, 0, textureFormat, GL_UNSIGNED_BYTE, surface->pixels);
	SDL_UnlockSurface(surface);

	// Cleanup
	SDL_FreeSurface(surface);
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);

	return image;
}

MOImage *MOImageCreateWithSize(MOSize aSize)
{
	// Create image
	MOImage *image = calloc(1, sizeof (MOImage));
	COInitialize(image, &MOImageClass);

	// Initalize
	image->size = aSize;
	image->graphicsContext = MOGraphicsContextCreate(MOImageGetBounds(image));

	// Create texture
	glGenTextures(1, &image->textureName);
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, image->textureName);
	glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, image->size.w, image->size.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);

	return image;
}

void _MOImageDestroy(void *aImage)
{
	MOImage *image = (MOImage *)aImage;
	glDeleteTextures(1, &image->textureName);
	CORelease(image->graphicsContext);
}

void MOImageLockFocus(MOImage *aImage)
{
	MOGraphicsContext_push(aImage->graphicsContext);
}

void MOImageUnlockFocus(MOImage *aImage)
{
	MOGraphicsContext_pop();
}

MORect MOImageGetBounds(MOImage *aImage)
{
	return MORectMake(0, 0, aImage->size.w, aImage->size.h);
}

// FIXME allow drawing into a MOImage instead
// FIXME what if sizes don’t match?
void MOImageTakeFromOnScreenRect(MOImage *aImage, MORect aRect)
{
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, aImage->textureName);
	glCopyTexSubImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, 0, 0, aRect.x, aRect.y, aRect.w, aRect.h);
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}

void MOImageDrawAtPoint(MOImage *aImage, MOPoint aPoint)
{
	// Get absolute destination
	MORect dstRect = MOGraphicsContext_getCurrentRect();
	MOPoint dstPoint = MOPointMake(dstRect.x + aPoint.x, dstRect.y + aPoint.y);

	// TODO [OpenGL] translate using matrixes

	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, aImage->textureName);
	glBegin(GL_QUADS);
	{
		// bottom left
		glTexCoord2i(0,                           0);
		glVertex2i(  dstPoint.x,                  dstPoint.y + aImage->size.h);

		// bottom right
		glTexCoord2i(aImage->size.w,              0);
		glVertex2i(  dstPoint.x + aImage->size.w, dstPoint.y + aImage->size.h);

		// top right
		glTexCoord2i(aImage->size.w,              aImage->size.h);
		glVertex2i(  dstPoint.x + aImage->size.w, dstPoint.y);

		// top left
		glTexCoord2i(0,                           aImage->size.h);
		glVertex2i(  dstPoint.x,                  dstPoint.y);
	}
	glEnd();
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}
