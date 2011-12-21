#ifndef __MONET_PRIVATE_H__
#define __MONET_PRIVATE_H__

#include <Monet/Monet.h>
#include <Monet/Common.h>

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

#endif
