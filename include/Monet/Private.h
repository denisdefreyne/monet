#import <Monet/Monet.h>

#import <OpenGL/gl.h>
#import <SDL/SDL.h>

@interface MOGraphicsContext (Private)

- (id)initWithTextureName:(GLuint)aTextureName rect:(MORect)aRect;

- (GLuint)textureName;

@end

@interface MOScreen (Private)

- (SDL_Surface *)surface;

@end

MOKey MOSDLKeyToMOKey(SDLKey aKey);
MOKeyModifierMask MOSDLModToMOKeyModifierMask(SDLMod aMod);
MOMouseButton MOSDLMouseButtonToMOMouseButton(Uint8 aButton);
