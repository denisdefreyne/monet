#import <Foundation/Foundation.h>

#import <Monet/MORect.h>

@class MOEvent;
@class MOGraphicsContext;
@class MOApplication;

@interface MOView : NSObject
{
	MOApplication		*app;

	MOView				*superview;
	NSMutableArray		*subviews;

	MORect				frame;
	MORect				bounds;

	MOGraphicsContext	*graphicsContext;
}

- (id)initWithFrame:(MORect)aFrame app:(MOApplication *)aApp;

- (MOApplication *)app;

- (MOView *)superview;
- (NSMutableArray *)subviews;
- (void)addSubview:(MOView *)aSubview;

- (MOPoint)convertPointFromScreen:(MOPoint)aPoint;
- (MOPoint)convertPointToScreen:(MOPoint)aPoint;

- (MOView *)subviewAtPoint:(MOPoint)aPoint;
- (MOView *)deepestSubviewAtPoint:(MOPoint)aPoint;

- (MORect)frame;
- (MORect)bounds;
- (MORect)boundsRelativeToWindow;

- (void)lockFocus;
- (void)unlockFocus;

- (void)display;
- (void)clear;
- (void)drawRect:(MORect)aRect;

// TODO move this into the controller
- (BOOL)keyDown:(MOEvent *)aEvent;
- (BOOL)keyUp:(MOEvent *)aEvent;
- (void)mouseDown:(MOEvent *)aEvent;
- (void)mouseUp:(MOEvent *)aEvent;
- (void)mouseDragged:(MOEvent *)aEvent;

// TODO move this into the controller
- (void)tick;

@end
