#import <Monet/MOTileset.h>

#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

@implementation MOTileset

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
	// Get context
	MOGraphicsContext *context = [MOGraphicsContext currentContext];

	// Get surfaces
	SDL_Surface *srcSurface	= surface;
	SDL_Surface *dstSurface	= [context surface];

	// Get clip rect
	MORect clipRect = [context rect];

	// Get source rect
	MORect srcRect;
	srcRect.x = aTilePoint.x * tileSize.w;
	srcRect.y = aTilePoint.y * tileSize.h;
	srcRect.w = tileSize.w;
	srcRect.h = tileSize.h;

	// Get destination rect
	MORect dstRect = [context rect];
	dstRect.x += aPoint.x;
	dstRect.y += aPoint.y;

	// Blit
	SDL_SetClipRect(dstSurface, &clipRect);
	SDL_BlitSurface(srcSurface, &srcRect, dstSurface, &dstRect);
	SDL_SetClipRect(dstSurface, NULL);
}

@end
