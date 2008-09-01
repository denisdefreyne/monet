#import <Foundation/Foundation.h>

#import <SDL/SDL.h>

#import <Monet/MOSize.h>

@class MOSpeedCounter;
@class MOView;
@class MOImage;

@interface MOScreen : NSObject
{
	// Dimensions
	MOSize			size;

	// Image and buffer
	SDL_Surface		*surface;

	// Timer stuff
	unsigned int	ticksPerSecond;
	SDL_TimerID		timerID;

	// Running or not?
	BOOL			isOpen;

	// Content view
	Class			contentViewClass;
	MOView			*contentView;

	// FPS counter
	MOSpeedCounter	*fpsCounter;

	// State information
	BOOL			leftMouseDown;
	BOOL			rightMouseDown;
}

- (MOView *)contentView;
- (void)setContentView:(MOView *)aContentView;
- (MOSize)size;
- (void)setSize:(MOSize)aSize;
- (UInt8)ticksPerSecond;
- (void)setTicksPerSecond:(UInt8)aTicksPerSecond;

- (void)open;
- (void)enterRunloop;
- (void)close;

- (void)update;

@end
