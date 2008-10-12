#import <Monet/MOImage.h>

#import <SDL/SDL.h>
#import <SDL/SDL_image.h>

#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

@implementation MOImage

- (id)initWithContentsOfFile:(NSString *)aFilename
{
	if(self = [super init])
	{
		// Load file
		SDL_Surface *surface = IMG_Load([aFilename UTF8String]);
		if(!surface)
			[NSException raise:@"SDLException" format:@"IMG_Load failed: %s\n", SDL_GetError()];

		// Create texture
		glGenTextures(1, &textureName);
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, textureName);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

		// Get number of colors and texture format
		GLint	numberOfColors = surface->format->BytesPerPixel;
		GLenum	textureFormat;
		if(numberOfColors == 4)
		{
			if (surface->format->Rmask == 0x000000ff)
				textureFormat = GL_RGBA;
			else
				textureFormat = GL_BGRA;
		}
		else if(numberOfColors == 3)
		{
			if (surface->format->Rmask == 0x000000ff)
				textureFormat = GL_RGB;
			else
				textureFormat = GL_BGR;
		}
		else
			// TODO handle gracefully
			[NSException raise:@"OpenGLException" format:@"glTexImage2D preparation failed: image is not in truecolor (filename = %@)\n", aFilename];

		// Set size
		size = MOMakeSize(surface->w, surface->h);

		// Fill texture
		SDL_LockSurface(surface);
		glTexImage2D(GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, size.w, size.h, 0, textureFormat, GL_UNSIGNED_BYTE, surface->pixels);
		SDL_UnlockSurface(surface);

		// Cleanup
		SDL_FreeSurface(surface);
		glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
	}

	return self;
}

- (id)initWithWidth:(UInt16)aWidth height:(UInt16)aHeight
{
	if(self = [super init])
	{
		// TODO [OpenGL] reimplement
		return nil;

		// // Create surface
		// SDL_Surface *tmpSurface = SDL_CreateRGBSurface(0, aWidth, aHeight, 32, 0, 0, 0, 0);
		// if(!tmpSurface)
		// 	[NSException raise:@"SDLException" format:@"SDL_CreateRGBSurface failed: %s\n", SDL_GetError()];
		// 
		// // Optimize surface
		// surface = SDL_DisplayFormat(tmpSurface);
		// if(!surface)
		// 	[NSException raise:@"SDLException" format:@"SDL_DisplayFormat failed: %s\n", SDL_GetError()];
		// SDL_FreeSurface(tmpSurface);
	}

	return self;
}

- (void)dealloc
{
	glDeleteTextures(1, &textureName);

	[graphicsContext release];

	[super dealloc];
}

#pragma mark -

- (void)lockFocus
{
	// Create graphics context if necessary
	if(!graphicsContext)
		graphicsContext = [[MOGraphicsContext alloc] initWithRect:[self bounds]];

	[[MOGraphicsContext stack] addObject:graphicsContext];
}

- (void)unlockFocus
{
	[[MOGraphicsContext stack] removeLastObject];
}

#pragma mark -

- (MORect)bounds
{
	return MOMakeRect(0, 0, size.w, size.h);
}

#pragma mark -

- (void)drawAtPoint:(MOPoint)aPoint
{
	// Get absolute destination
	MORect dstRect = [[MOGraphicsContext currentContext] rect];
	MOPoint dstPoint = MOMakePoint(dstRect.x + aPoint.x, dstRect.y + aPoint.y);

	// TODO [OpenGL] translate using matrixes

	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, textureName);
	glBegin(GL_QUADS);
	{
		// FIXME [OpenGL] allow drawing into textures

		// bottom left
		glTexCoord2i(	0,							0);
		glVertex2i(		dstPoint.x,					dstPoint.y);

		// bottom right
		glTexCoord2i(	size.w,						0);
		glVertex2i(		dstPoint.x + size.w,		dstPoint.y);

		// top right
		glTexCoord2i(	size.w,						size.h);
		glVertex2i(		dstPoint.x + size.w,		dstPoint.y + size.h);

		// top left
		glTexCoord2i(	0,							size.h);
		glVertex2i(		dstPoint.x,					dstPoint.y + size.h);
	}
	glEnd();
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
}

@end
