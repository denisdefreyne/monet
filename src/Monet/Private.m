#import <Monet/Private.h>

@implementation MOGraphicsContext (Private)

- (id)initWithTextureName:(GLuint)aTextureName rect:(MORect)aRect
{
	if(self = [super init])
	{
		textureName	= aTextureName;
		rect		= aRect;
	}

	return self;
}

- (GLuint)textureName
{
	return textureName;
}

@end

@implementation MOScreen (Private)

- (SDL_Surface *)surface
{
	return surface;
}

@end

MOKey MOSDLKeyToMOKey(SDLKey aKey)
{
	switch(aKey)
	{
		case SDLK_UP:						return MOUpArrowKey;
		case SDLK_DOWN:						return MODownArrowKey;
		case SDLK_LEFT:						return MOLeftArrowKey;
		case SDLK_RIGHT:					return MORightArrowKey;

		case SDLK_CAPSLOCK:					return MOCapsLockKey;
		case SDLK_LSHIFT: case SDLK_RSHIFT:	return MOShiftKey;
		case SDLK_LCTRL: case SDLK_RCTRL:	return MOControlKey;
		case SDLK_LALT: case SDLK_RALT:		return MOAlternateKey;

		case SDLK_HOME:						return MOHomeKey;
		case SDLK_END:						return MOEndKey;
		case SDLK_PAGEUP:					return MOPageUpKey;
		case SDLK_PAGEDOWN:					return MOPageDownKey;

		case SDLK_BACKSPACE:				return MOBackspaceKey;
		case SDLK_DELETE:					return MODeleteKey;

		case SDLK_F1:						return MOF1Key;
		case SDLK_F2:						return MOF2Key;
		case SDLK_F3:						return MOF3Key;
		case SDLK_F4:						return MOF4Key;
		case SDLK_F5:						return MOF5Key;
		case SDLK_F6:						return MOF6Key;
		case SDLK_F7:						return MOF7Key;
		case SDLK_F8:						return MOF8Key;
		case SDLK_F9:						return MOF9Key;
		case SDLK_F10:						return MOF10Key;
		case SDLK_F11:						return MOF11Key;
		case SDLK_F12:						return MOF12Key;
		case SDLK_F13:						return MOF13Key;
		case SDLK_F14:						return MOF14Key;
		case SDLK_F15:						return MOF15Key;

		default:							return MOUnknownKey;
	}
}

MOKeyModifierMask MOSDLModToMOKeyModifierMask(SDLMod aMod)
{
	MOKeyModifierMask keyModifierMask;

	if(aMod & KMOD_CAPS)
		keyModifierMask |= MOCapsLockKeyMask;

	if(aMod & KMOD_SHIFT)
		keyModifierMask |= MOShiftKeyMask;

	if(aMod & KMOD_CTRL)
		keyModifierMask |= MOControlKeyMask;

	if(aMod & KMOD_ALT)
		keyModifierMask |= MOAlternateKeyMask;

	return keyModifierMask;
}

MOMouseButton MOSDLMouseButtonToMOMouseButton(Uint8 aButton)
{
	switch(aButton)
	{
		case SDL_BUTTON_LEFT:	return MOLeftMouseButton;
		case SDL_BUTTON_MIDDLE:	return MOLeftMouseButton;
		case SDL_BUTTON_RIGHT:	return MOLeftMouseButton;

		default:				return MOUnknownMouseButton;
	}
}
