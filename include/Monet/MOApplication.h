#import <Foundation/Foundation.h>

#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

@class MOView;

@interface MOApplication : NSObject
{
	struct MOApplicationData *applicationData;
}

- (id)world;
- (void)setWorld: (id)aWorld;
- (MOView *)mainView;
- (void)setMainView: (MOView *)aMainView;
- (MOSize)screenSize;
- (void)setScreenSize: (MOSize)aSize;
- (BOOL)isFullscreen;
- (void)setFullscreen: (BOOL)aIsFullscreen;
- (uint8_t)gameTicksPerSecond;
- (void)setGameTicksPerSecond: (uint8_t)aGameTicksPerSecond;
- (uint8_t)maxFrameSkip;
- (void)setMaxFrameSkip: (uint8_t)aMaxFrameSkip;

- (void)openScreen;
- (void)enterRunloop;
- (void)closeScreen;

- (float)interpolation;
- (MOPoint)mouseLocation;

@end
