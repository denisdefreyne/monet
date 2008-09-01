#import <Monet/Private.h>

@implementation MOGraphicsContext (Private)

- (id)initWithSurface:(SDL_Surface *)aSurface rect:(MORect)aRect;
{
	if(self = [super init])
	{
		if(!aSurface)
			[NSException raise:NSInvalidArgumentException format:@"MOGraphicsContext requires a SDL_Surface"];

		surface = aSurface;
		rect = aRect;
	}

	return self;
}

- (SDL_Surface *)surface
{
	return surface;
}

@end

@implementation MOScreen (Private)

- (SDL_Surface *)surface
{
	return surface;
}

@end
