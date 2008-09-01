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
		surface = IMG_Load([aFilename UTF8String]);
		if(!surface)
			[NSException raise:@"SDLException" format:@"IMG_Load failed: %s\n", SDL_GetError()];
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

	// Get destination rect
	MORect rect = [context rect];
	SDL_Rect dstRect;
	dstRect.x = rect.origin.x + aPoint.x;
	dstRect.y = rect.origin.y + aPoint.y;
	dstRect.w = rect.size.width;
	dstRect.h = rect.size.height;

	// Blit
	SDL_BlitSurface(srcSurface, NULL, dstSurface, &dstRect);
}

@end
