#import <Foundation/Foundation.h>

// FIXME remove these headers
#import <SDL/SDL.h>

#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

@class MOSpeedCounter;
@class MOView;
@class MOImage;

@interface MOScreen : NSObject
{
	// Pool
	NSAutoreleasePool	*autoreleasePool;

	// Dimensions
	MOSize				size;
	BOOL				isFullscreen;

	// Image and buffer
	SDL_Surface			*surface;

	// Running or not?
	BOOL				isOpen;

	// Content view
	MOView				*contentView;

	// Timing
	UInt8				gameTicksPerSecond;
	float				interpolation;

	// FPS counter
	MOSpeedCounter		*fpsCounter;

	// Recent views receiving mouse button events
	MOView				*lastLeftMouseButtonDownView;
	MOView				*lastMiddleMouseButtonDownView;
	MOView				*lastRightMouseButtonDownView;
}

- (MOView *)contentView;
- (void)setContentView:(MOView *)aContentView;
- (MOSize)size;
- (void)setSize:(MOSize)aSize;
- (BOOL)isFullscreen;
- (void)setFullscreen:(BOOL)aIsFullscreen;
- (UInt8)gameTicksPerSecond;
- (void)setGameTicksPerSecond:(UInt8)aGameTicksPerSecond;

- (float)interpolation;
- (void)setInterpolation:(float)aInterpolation;

- (void)open;
- (void)enterRunloop;
- (void)close;

- (MOPoint)mouseLocation;

- (void)screenDidLoad;
- (void)update;

@end
