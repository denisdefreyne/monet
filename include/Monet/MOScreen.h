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

	// Surface
	SDL_Surface			*surface;
	MOSize				size;
	BOOL				isFullscreen;

	// Running or not?
	BOOL				isOpen;

	// Model
	id					model;

	// View
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

- (id)model;
- (void)setModel:(id)aModel;
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

@end
