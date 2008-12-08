#import <Foundation/Foundation.h>

// FIXME remove these headers
#import <SDL/SDL.h>

#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

@class MOSpeedCounter;
@class MOView;
@class MOImage;

@interface MOApplication : NSObject
{
	// Pool
	NSAutoreleasePool	*autoreleasePool;

	// Surface
	SDL_Surface			*surface;
	MOSize				screenSize;
	BOOL				isFullscreen;

	// Running or not?
	BOOL				isOpen;

	// Model
	id					model;

	// View
	MOView				*mainView;

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
- (MOView *)mainView;
- (void)setMainView:(MOView *)aMainView;
- (MOSize)screenSize;
- (void)setScreenSize:(MOSize)aSize;
- (BOOL)isFullscreen;
- (void)setFullscreen:(BOOL)aIsFullscreen;
- (UInt8)gameTicksPerSecond;
- (void)setGameTicksPerSecond:(UInt8)aGameTicksPerSecond;

- (float)interpolation;
- (void)setInterpolation:(float)aInterpolation;

- (void)openScreen;
- (void)enterRunloop;
- (void)closeScreen;

- (MOPoint)mouseLocation;

- (void)screenDidLoad;

@end
