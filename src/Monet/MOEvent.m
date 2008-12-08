#import <Monet/MOEvent.h>

struct MOEventData
{
	MOEventType     type;
	UInt8           modifiers;
    
	NSString        *character;
	MOKey           key;
    
	MOMouseButton   mouseButton;
	MOPoint         mouseLocation;
	MOPoint         relativeMouseMotion;
	UInt8           clickCount;
};

@implementation MOEvent

- (id)initKeyEventWithType:(MOEventType)aType modifiers:(UInt8)aModifiers character:(NSString *)aCharacter key:(MOKey)aKey
{
	if(self = [super init])
	{
		eventData = calloc(1, sizeof (struct MOEventData));

		eventData->type      = aType;
		eventData->modifiers = aModifiers;

		eventData->character = [aCharacter retain];
		eventData->key       = aKey;
	}

	return self;
}

- (id)initMouseButtonEventWithType:(MOEventType)aType modifiers:(UInt8)aModifiers mouseButton:(MOMouseButton)aMouseButton mouseLocation:(MOPoint)aMouseLocation clickCount:(UInt8)aClickCount
{
	if(self = [super init])
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

- (id)initMouseMotionEventWithModifiers:(UInt8)aModifiers mouseLocation:(MOPoint)aMouseLocation relativeMouseMotion:(MOPoint)aRelativeMouseMotion
{
	if(self = [super init])
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

- (UInt8)modifiers
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

- (UInt8)clickCount
{
	return eventData->clickCount;
}

@end
