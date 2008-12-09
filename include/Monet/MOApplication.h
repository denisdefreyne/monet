#import <Foundation/Foundation.h>

#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

@class MOView;

@interface MOApplication : NSObject
{
	struct MOApplicationData *applicationData;
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
