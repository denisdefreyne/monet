#import <Monet/MOImage.h>

#import <SDL/SDL.h>
#import <SDL_image/SDL_image.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

@implementation MOImage

- (id)initWithContentsOfFile: (NSString *)aFilename
{
	if (self = [super init])
	{
		// Create data
		imageData = calloc(1, sizeof (struct MOImageData));

		// Load file
		SDL_Surface *surface = IMG_Load([aFilename UTF8String]);
		if (!surface)
			[NSException raise: @"SDLException" format: @"IMG_Load failed: %s\n", SDL_GetError()];

		// Create texture
		glGenTextures(1, &imageData->textureName);
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, imageData->textureName);
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
			// TODO handle gracefully
			[NSException raise: @"OpenGLException" format: @"glTexImage2D preparation failed: image is not in truecolor (filename = %@)\n", aFilename];

		// Set size
		imageData->size = MOSizeMake(surface->w, surface->h);

		// Fill texture
		SDL_LockSurface(surface);
		glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, imageData->size.w, imageData->size.h, 0, textureFormat, GL_UNSIGNED_BYTE, surface->pixels);
		SDL_UnlockSurface(surface);

		// Cleanup
		SDL_FreeSurface(surface);
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
	}

	return self;
}

- (id)initWithWidth: (uint16_t)aWidth height: (uint16_t)aHeight
{
	if (self = [super init])
	{
		// Create data
		imageData = calloc(1, sizeof (struct MOImageData));

		// Set size
		imageData->size = MOSizeMake(aWidth, aHeight);

		// Create texture
		glGenTextures(1, &imageData->textureName);
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, imageData->textureName);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, imageData->size.w, imageData->size.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);

		// Cleanup
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
	}

	return self;
}

- (void)dealloc
{
	glDeleteTextures(1, &imageData->textureName);

	[imageData->graphicsContext release];

	[super dealloc];
}

#pragma mark -

- (void)lockFocus
{
	// Create graphics context if necessary
	if (!imageData->graphicsContext)
		imageData->graphicsContext = [[MOGraphicsContext alloc] initWithRect: [self bounds]];

	[[MOGraphicsContext stack] addObject: imageData->graphicsContext];
}

- (void)unlockFocus
{
	[[MOGraphicsContext stack] removeLastObject];
}

#pragma mark -

- (MORect)bounds
{
	return MORectMake(0, 0, imageData->size.w, imageData->size.h);
}

#pragma mark -

- (void)takeImageFromRect: (MORect)aRect
{
	// Bind
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, imageData->textureName);

	// Copy
	glCopyTexSubImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, 0, 0, aRect.x, aRect.y, aRect.w, aRect.h);

	// Unbind
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}

#pragma mark -

- (void)drawAtPoint: (MOPoint)aPoint
{
	// Get absolute destination
	MORect dstRect = [[MOGraphicsContext currentContext] rect];
	MOPoint dstPoint = MOPointMake(dstRect.x + aPoint.x, dstRect.y + aPoint.y);

	// TODO [OpenGL] translate using matrixes

	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, imageData->textureName);
	glBegin(GL_QUADS);
	{
		// bottom left
		glTexCoord2i(	0,							0);
		glVertex2i(		dstPoint.x,					dstPoint.y + imageData->size.h);

		// bottom right
		glTexCoord2i(	imageData->size.w,				0);
		glVertex2i(		dstPoint.x + imageData->size.w,	dstPoint.y + imageData->size.h);

		// top right
		glTexCoord2i(	imageData->size.w,				imageData->size.h);
		glVertex2i(		dstPoint.x + imageData->size.w,	dstPoint.y);

		// top left
		glTexCoord2i(	0,							imageData->size.h);
		glVertex2i(		dstPoint.x,					dstPoint.y);
	}
	glEnd();
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}

@end
