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
	BOOL			isFullscreen;

	// Image and buffer
	SDL_Surface		*surface;

	// Running or not?
	BOOL			isOpen;

	// Content view
	MOView			*contentView;

	// FPS counter
	MOSpeedCounter	*fpsCounter;

	// Recent views receiving mouse button events
	MOView			*lastLeftMouseButtonDownView;
	MOView			*lastMiddleMouseButtonDownView;
	MOView			*lastRightMouseButtonDownView;
}

- (MOView *)contentView;
- (void)setContentView:(MOView *)aContentView;
- (MOSize)size;
- (void)setSize:(MOSize)aSize;
- (BOOL)isFullscreen;
- (void)setFullscreen:(BOOL)aIsFullscreen;

- (void)open;
- (void)enterRunloop;
- (void)close;

- (void)screenDidLoad;
- (void)update;

@end
