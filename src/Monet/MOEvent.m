#import <Monet/MOEvent.h>

@implementation MOEvent

- (id)initKeyEventWithType:(MOEventType)aType modifiers:(UInt8)aModifiers character:(NSString *)aCharacter key:(MOKey)aKey
{
	if(self = [super init])
	{
		type		= aType;
		modifiers	= aModifiers;

		character	= [aCharacter retain];
		key			= aKey;
	}

	return self;
}

- (id)initMouseButtonEventWithType:(MOEventType)aType modifiers:(UInt8)aModifiers mouseButton:(MOMouseButton)aMouseButton clickCount:(UInt8)aClickCount
{
	if(self = [super init])
	{
		type		= aType;
		modifiers	= aModifiers;

		mouseButton	= aMouseButton;
		clickCount	= aClickCount;
	}

	return self;
}

- (void)dealloc
{
	[character release];

	[super dealloc];
}

#pragma mark -

- (MOEventType)type
{
	return type;
}

- (UInt8)modifiers
{
	return modifiers;
}

#pragma mark -

- (NSString *)character
{
	return character;
}

- (MOKey)key
{
	return key;
}

#pragma mark -

- (MOMouseButton)mouseButton
{
	return mouseButton;
}

- (UInt8)clickCount
{
	return clickCount;
}

@end