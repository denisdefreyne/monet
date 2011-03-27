#import <Foundation/Foundation.h>

#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

@class MOState;
@class MOView;

@interface MOApplication : NSObject
{
	struct MOApplicationData *applicationData;
}

- (id)world;
- (void)setWorld: (id)aWorld;
- (MOSize)screenSize;
- (void)setScreenSize: (MOSize)aSize;
- (BOOL)isFullscreen;
- (void)setFullscreen: (BOOL)aIsFullscreen;
- (uint8_t)gameTicksPerSecond;
- (void)setGameTicksPerSecond: (uint8_t)aGameTicksPerSecond;
- (uint8_t)maxFrameSkip;
- (void)setMaxFrameSkip: (uint8_t)aMaxFrameSkip;

- (MOState *)currentState;
- (void)pushState: (MOState *)aState;
- (MOState *)popCurrentState;
- (MOState *)replaceCurrentStateWith: (MOState *)aState;

- (void)openScreen;
- (void)enterRunloop;
- (void)closeScreen;

- (float)interpolation;
- (MOPoint)mouseLocation;

@end
