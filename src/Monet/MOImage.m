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
		SDL_Surface *tmpSurface = IMG_Load([aFilename UTF8String]);
		if(!tmpSurface)
			[NSException raise:@"SDLException" format:@"IMG_Load failed: %s\n", SDL_GetError()];

		// Optimize surface
		surface = SDL_DisplayFormat(tmpSurface);
		if(!surface)
			[NSException raise:@"SDLException" format:@"SDL_DisplayFormat failed: %s\n", SDL_GetError()];
		SDL_FreeSurface(tmpSurface);
	}

	return self;
}

- (void)dealloc
{
	SDL_FreeSurface(surface);

	[graphicsContext release];

	[super dealloc];
}

#pragma mark -

- (void)lockFocus
{
	if(!graphicsContext)
		graphicsContext = [[MOGraphicsContext alloc] initWithSurface:surface rect:[self bounds]];

	[[MOGraphicsContext stack] addObject:graphicsContext];
}

- (void)unlockFocus
{
	[[MOGraphicsContext stack] removeLastObject];
}

#pragma mark -

- (MORect)bounds
{
	return MOMakeRect(0, 0, surface->w, surface->h);
}

#pragma mark -

- (void)drawAtPoint:(MOPoint)aPoint
{
	// Get context
	MOGraphicsContext *context = [MOGraphicsContext currentContext];

	// Get surfaces
	SDL_Surface *srcSurface	= surface;
	SDL_Surface *dstSurface	= [context surface];

	// Get clip rect
	MORect clipRect = [context rect];

	// Get destination rect
	MORect dstRect = [context rect];
	dstRect.x += aPoint.x;
	dstRect.y += aPoint.y;

	// Blit
	SDL_SetClipRect(dstSurface, &clipRect);
	SDL_BlitSurface(srcSurface, NULL, dstSurface, &dstRect);
	SDL_SetClipRect(dstSurface, NULL);
}

@end