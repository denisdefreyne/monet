#import <Monet/MOTimer.h>

#import <SDL/SDL.h>

struct MOTimerData
{
	SDL_TimerID	timerID;

	uint32_t		interval;

	id			target;
	SEL			selector;

	void		*userInfo;
};

Uint32 timerCallback(Uint32 interval, void *param)
{
	MOTimer *timer = (MOTimer *)param;

	[[timer target] performSelector: [timer selector] withObject: timer];

	return [timer interval];
}

@implementation MOTimer

- (id)initWithTarget: (id)aTarget selector: (SEL)aSelector interval: (uint32_t)aInterval userInfo: (void *)aUserInfo
{
	if ((self = [super init]))
	{
		timerData = calloc(1, sizeof(struct MOTimerData));

		timerData->target = aTarget;
		timerData->selector = aSelector;

		timerData->interval = aInterval;

		timerData->userInfo = aUserInfo;
	}

	return self;
}

- (void)dealloc
{
	[self stop];

	[super dealloc];
}

#pragma mark -

- (id)target
{
	return timerData->target;
}

- (SEL)selector
{
	return timerData->selector;
}

- (uint32_t)interval
{
	return timerData->interval;
}

- (void *)userInfo
{
	return timerData->userInfo;
}

#pragma mark -

- (void)start
{
	timerData->timerID = SDL_AddTimer(timerData->interval, &timerCallback, self);
}

- (void)stop
{
	SDL_RemoveTimer(timerData->timerID);
}

@end
