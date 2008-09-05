#import <Monet/Monet.h>

#import <SDL/SDL.h>

@interface MOGraphicsContext (Private)

- (id)initWithSurface:(SDL_Surface *)aSurface rect:(MORect)aRect;

- (SDL_Surface *)surface;

@end

@interface MOScreen (Private)

- (SDL_Surface *)surface;

@end

MOKey MOSDLKeyToMOKey(SDLKey aKey);
MOKeyModifierMask MOSDLModToMOKeyModifierMask(SDLMod aMod);
