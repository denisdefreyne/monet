#import <Monet/Monet.h>

#import <cobject/cobject.h>
#import <SDL/SDL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

struct _MOImage
{
	COGuts            *guts;

	GLuint            textureName;
	MOSize            size;
	MOGraphicsContext *graphicsContext;
};

struct _MOTiledImage
{
	COGuts  *guts;

	MOImage *image;
	MOSize  tileSize;
};

struct _MOGraphicsContext
{
	COGuts *guts;

	MORect rect;
};

MOGraphicsContext *MOGraphicsContextCreate(MORect aRect);

MOKey MOSDLKeyToMOKey(SDLKey aKey);
MOKeyModifierMask MOSDLModToMOKeyModifierMask(SDLMod aMod);
MOMouseButton MOSDLMouseButtonToMOMouseButton(Uint8 aButton);
