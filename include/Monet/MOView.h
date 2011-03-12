#import <Foundation/Foundation.h>

#import <Monet/MORect.h>

@class MOController;
@class MOEvent;
@class MOApplication;

@interface MOView : NSObject
{
	struct MOViewData *viewData;
}

- (id)initWithFrame: (MORect)aFrame app: (MOApplication *)aApp;

- (MOApplication *)app;

- (MOView *)superview;
- (NSArray *)subviews;
- (void)addSubview: (MOView *)aSubview;

- (MOPoint)convertPointFromScreen: (MOPoint)aPoint;
- (MOPoint)convertPointToScreen: (MOPoint)aPoint;

- (MOView *)subviewAtPoint: (MOPoint)aPoint;
- (MOView *)deepestSubviewAtPoint: (MOPoint)aPoint;

- (MORect)frame;
- (MORect)bounds;
- (MORect)boundsRelativeToWindow;

- (void)lockFocus;
- (void)unlockFocus;

- (void)display;
- (void)clear;
- (void)drawRect: (MORect)aRect;

- (Class)controllerClass;
- (MOController *)controller;

@end
