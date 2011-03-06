#import <Monet/MOEvent.h>

struct MOEventData
{
	MOEventType     type;
	uint8_t           modifiers;
    
	NSString        *character;
	MOKey           key;
    
	MOMouseButton   mouseButton;
	MOPoint         mouseLocation;
	MOPoint         relativeMouseMotion;
	uint8_t           clickCount;
};

@implementation MOEvent

- (id)initKeyEventWithType: (MOEventType)aType modifiers: (uint8_t)aModifiers character: (NSString *)aCharacter key: (MOKey)aKey
{
	if (self = [super init])
	{
		eventData = calloc(1, sizeof (struct MOEventData));

		eventData->type      = aType;
		eventData->modifiers = aModifiers;

		eventData->character = [aCharacter retain];
		eventData->key       = aKey;
	}

	return self;
}

- (id)initMouseButtonEventWithType: (MOEventType)aType modifiers: (uint8_t)aModifiers mouseButton: (MOMouseButton)aMouseButton mouseLocation: (MOPoint)aMouseLocation clickCount: (uint8_t)aClickCount
{
	if (self = [super init])
	{
		eventData = calloc(1, sizeof (struct MOEventData));

		eventData->type          = aType;
		eventData->modifiers     = aModifiers;
        
		eventData->mouseButton   = aMouseButton;
		eventData->mouseLocation = aMouseLocation;
		eventData->clickCount    = aClickCount;
	}

	return self;
}

- (id)initMouseMotionEventWithModifiers: (uint8_t)aModifiers mouseLocation: (MOPoint)aMouseLocation relativeMouseMotion: (MOPoint)aRelativeMouseMotion
{
	if (self = [super init])
	{
		eventData = calloc(1, sizeof (struct MOEventData));

		eventData->type                = MOMouseMotionEventType;
		eventData->modifiers           = aModifiers;
        
		eventData->mouseLocation       = aMouseLocation;
		eventData->relativeMouseMotion = aRelativeMouseMotion;
	}

	return self;
}

- (void)dealloc
{
	[eventData->character release];

	[super dealloc];
}

#pragma mark -

- (MOEventType)type
{
	return eventData->type;
}

- (uint8_t)modifiers
{
	return eventData->modifiers;
}

#pragma mark -

- (NSString *)character
{
	return eventData->character;
}

- (MOKey)key
{
	return eventData->key;
}

#pragma mark -

- (MOMouseButton)mouseButton
{
	return eventData->mouseButton;
}

- (MOPoint)mouseLocation
{
	return eventData->mouseLocation;
}

- (MOPoint)relativeMouseMotion
{
	return eventData->relativeMouseMotion;
}

- (uint8_t)clickCount
{
	return eventData->clickCount;
}

@end
