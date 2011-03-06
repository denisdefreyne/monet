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
- (UInt8)gameTicksPerSecond;
- (void)setGameTicksPerSecond: (UInt8)aGameTicksPerSecond;
- (UInt8)maxFrameSkip;
- (void)setMaxFrameSkip: (UInt8)aMaxFrameSkip;

- (void)openScreen;
- (void)enterRunloop;
- (void)closeScreen;

- (float)interpolation;
- (MOPoint)mouseLocation;

@end
