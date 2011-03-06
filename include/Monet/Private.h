#import <Monet/Monet.h>

#import <SDL/SDL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

struct MOGraphicsContextData
{
	MORect rect;
};

struct MOImageData
{
	GLuint            textureName;
	MOSize            size;
	MOGraphicsContext *graphicsContext;
};

@interface MOGraphicsContext (Private)

- (id)initWithRect: (MORect)aRect;

@end

MOKey MOSDLKeyToMOKey(SDLKey aKey);
MOKeyModifierMask MOSDLModToMOKeyModifierMask(SDLMod aMod);
MOMouseButton MOSDLMouseButtonToMOMouseButton(Uint8 aButton);
