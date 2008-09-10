#import "Monet/MOTimer.h"

Uint32 timerCallback(Uint32 interval, void *param)
{
	MOTimer *timer = (MOTimer *)param;

	[[timer target] performSelector:[timer selector] withObject:timer];

	return [timer interval];
}

@implementation MOTimer

- (id)initWithTarget:(id)aTarget selector:(SEL)aSelector interval:(UInt32)aInterval userInfo:(void *)aUserInfo
{
	if(self = [super init])
	{
		target = aTarget;
		selector = aSelector;

		interval = aInterval;

		userInfo = aUserInfo;
	}

	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark -

- (id)target
{
	return target;
}

- (SEL)selector
{
	return selector;
}

- (UInt32)interval
{
	return interval;
}

- (void *)userInfo
{
	return userInfo;
}

#pragma mark -

- (void)start
{
	timerID = SDL_AddTimer(interval, &timerCallback, self);
}

- (void)stop
{
	SDL_RemoveTimer(timerID);
}

@end
