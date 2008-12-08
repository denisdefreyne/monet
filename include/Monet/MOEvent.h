#import <Foundation/Foundation.h>

#import <Monet/MOPoint.h>

// Keyboard events example:
//
// Support you type SHIFT-OPTION-O to get an Ø character. The following
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

	MOMouseMotionEventType
};
typedef UInt8 MOEventType;

enum {
	MOUnknownMouseButton = 0,

	MOLeftMouseButton,
	MOMiddleMouseButton,
	MORightMouseButton
};
typedef UInt8 MOMouseButton;

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
typedef UInt8 MOKey;

enum {
	MOCapsLockKeyMask	= 0x01,
	MOShiftKeyMask		= 0x02,
	MOControlKeyMask	= 0x04,
	MOAlternateKeyMask	= 0x08
};
typedef UInt8 MOKeyModifierMask;

@interface MOEvent : NSObject
{
@protected
	struct MOEventData *eventData;
}

- (id)initKeyEventWithType:(MOEventType)aType modifiers:(UInt8)aModifiers character:(NSString *)aCharacter key:(MOKey)aKey;
- (id)initMouseButtonEventWithType:(MOEventType)aType modifiers:(UInt8)aModifiers mouseButton:(MOMouseButton)aMouseButton mouseLocation:(MOPoint)aMouseLocation clickCount:(UInt8)aClickCount;
- (id)initMouseMotionEventWithModifiers:(UInt8)aModifiers mouseLocation:(MOPoint)aMouseLocation relativeMouseMotion:(MOPoint)aRelativeMouseMotion;

// General

- (MOEventType)type;
- (UInt8)modifiers;

// Keyboard-specific

- (NSString *)character;
- (MOKey)key;

// Mouse button-specific

- (MOMouseButton)mouseButton;
- (MOPoint)mouseLocation;
- (MOPoint)relativeMouseMotion;
- (UInt8)clickCount;

@end
