#ifndef __MONET_MOEVENT_H__
#define __MONET_MOEVENT_H__

#include <Monet/Common.h>

extern COClass MOEventClass;

typedef uint8_t MOEventType;
typedef uint8_t MOMouseButton;
typedef uint8_t MOKey;
typedef uint8_t MOKeyModifierMask;
typedef struct _MOEvent MOEvent;

#include <Monet/MOPoint.h>
#include <Monet/MOTimer.h>

// Keyboard events example:
//
// Suppose you type SHIFT-OPTION-O to get an Ø character. The following
// events will be dispatched:
//
// 1. type = key down, mod = shift,        char = '',  key = shift
// 2. type = key down, mod = shift|option, char = '',  key = option
// 3. type = key down, mod = shift|option, char = 'Ø', key = -
//
// When the keys are released, the following events will be dispatched:
//
// 1. type = key up,   mod = shift|option, char = '', key = -
// 2. type = key up,   mod = shift,        char = '', key = option
// 3. type = key up,   mod = -,            char = '', key = shift

enum {
	MOFocusGainedEventType,
	MOFocusLostEventType,

	MOKeyDownEventType,
	MOKeyUpEventType,

	MOMouseButtonDownEventType,
	MOMouseButtonUpEventType,
	MOMouseMotionEventType,

	MOTimerFiredEventType
};

enum {
	MOUnknownMouseButton = 0,

	MOLeftMouseButton,
	MOMiddleMouseButton,
	MORightMouseButton
};

enum {
	MOUnknownKey = 0,

	MOUpArrowKey,
	MODownArrowKey,
	MOLeftArrowKey,
	MORightArrowKey,

	MOCapsLockKey,
	MOShiftKey,
	MOControlKey,
	MOAlternateKey,

	MOHomeKey,
	MOEndKey,
	MOPageUpKey,
	MOPageDownKey,

	MOEscapeKey,

	MOF1Key,
	MOF2Key,
	MOF3Key,
	MOF4Key,
	MOF5Key,
	MOF6Key,
	MOF7Key,
	MOF8Key,
	MOF9Key,
	MOF10Key,
	MOF11Key,
	MOF12Key,
	MOF13Key,
	MOF14Key,
	MOF15Key,

	MOBackspaceKey,
	MODeleteKey
};

enum {
	MOCapsLockKeyMask  = 0x01,
	MOShiftKeyMask     = 0x02,
	MOControlKeyMask   = 0x04,
	MOAlternateKeyMask = 0x08,
	MOMetaKeyMask      = 0x10
};

MOEvent *MOEventCreateKey(MOEventType aType, MOKeyModifierMask aModifiers, char *aCharacter, MOKey aKey);
MOEvent *MOEventCreateMouseButton(MOEventType aType, MOKeyModifierMask aModifiers, MOMouseButton aMouseButton, MOPoint aMouseLocation, uint8_t aClickCount);
MOEvent *MOEventCreateMouseMotion(MOKeyModifierMask aModifiers, MOPoint aMouseLocation, MOPoint aRelativeMouseMotion);
MOEvent *MOEventCreateTimer(MOTimer *aTimer);

MOEventType MOEventGetType(MOEvent *aEvent);
MOKeyModifierMask MOEventGetModifiers(MOEvent *aEvent);

char *MOEventGetCharacter(MOEvent *aEvent);
MOKey MOEventGetKey(MOEvent *aEvent);

MOMouseButton MOEventGetMouseButton(MOEvent *aEvent);
MOPoint MOEventGetMouseLocation(MOEvent *aEvent);
MOPoint MOEventGetRelativeMouseMotion(MOEvent *aEvent);
uint8_t MOEventGetClickCount(MOEvent *aEvent);

MOTimer *MOEventGetTimer(MOEvent *aEvent);

#endif
