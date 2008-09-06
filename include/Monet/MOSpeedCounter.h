#import <Foundation/Foundation.h>

#import <Monet/Types.h>

@interface MOSpeedCounter : NSObject
{
	time_t	lastSecond;
	UInt16	accumulatedTicksPerSecond;
	UInt16	ticksPerSecond;
}

// Registers a tick.
- (void)tick;

// Returns the speed in number of ticks per second.
- (UInt16)ticksPerSecond;

// Returns true if the counter has begun a new second.
- (BOOL)isAtNewSecond;

@end
