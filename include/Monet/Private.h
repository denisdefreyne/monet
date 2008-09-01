#include <Monet/Monet.h>

@interface MOGraphicsContext (Private)

- (id)initWithSurface:(SDL_Surface *)aSurface rect:(MORect)aRect;

- (SDL_Surface *)surface;

@end

@interface MOScreen (Private)

- (SDL_Surface *)surface;

@end
