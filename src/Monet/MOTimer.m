#import <Monet/MOTimer.h>

#import <SDL/SDL.h>

struct MOTimerData
{
	SDL_TimerID	timerID;

	uint32_t    interval;
	double      duration;

	void        *userInfo;
};

Uint32 timerCallback(Uint32 interval, void *param)
{
	MOTimer *timer = (MOTimer *)param;

	SDL_Event event;
	event.type = SDL_USEREVENT;
	event.user.data1 = timer;
	SDL_PushEvent(&event);

	return [timer duration];
}

@implementation MOTimer

- (id)initWithDuration: (double)aDuration userInfo: (void *)aUserInfo
{
	if ((self = [super init]))
	{
		timerData = calloc(1, sizeof(struct MOTimerData));

		timerData->duration = aDuration;
		timerData->userInfo = aUserInfo;
	}

	return self;
}

- (void)dealloc
{
	[self stop];
	free(timerData);

	[super dealloc];
}

#pragma mark -

- (double)duration
{
	return timerData->duration;
}

- (void *)userInfo
{
	return timerData->userInfo;
}

#pragma mark -

- (void)start
{
	timerData->timerID = SDL_AddTimer(
		(uint32_t)(timerData->duration * 1000.0),
		&timerCallback,
		self);
}

- (void)stop
{
	SDL_RemoveTimer(timerData->timerID);
}

@end
