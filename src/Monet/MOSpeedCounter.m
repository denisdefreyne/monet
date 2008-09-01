#import <Monet/MOSpeedCounter.h>

#import <time.h>

@implementation MOSpeedCounter

- (id)init
{
	if(self = [super init])
	{
		lastSecond = time(NULL);
		accumulatedTicksPerSecond = 0;
		ticksPerSecond = 0;
	}

	return self;
}

- (void)tick
{
	++accumulatedTicksPerSecond;

	time_t newSecond = time(NULL);
	if(newSecond != lastSecond)
	{
		lastSecond = newSecond;
		ticksPerSecond = accumulatedTicksPerSecond;
		accumulatedTicksPerSecond = 0;
	}
}

- (UInt16)ticksPerSecond
{
	return ticksPerSecond;
}

- (BOOL)isAtNewSecond
{
	return 0 == accumulatedTicksPerSecond;
}

@end
