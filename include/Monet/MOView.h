#import <Foundation/Foundation.h>

#import <Monet/MORect.h>

@class MOEvent;
@class MOGraphicsContext;
@class MOScreen;

@interface MOView : NSObject
{
	MOScreen			*screen;

	MOView				*superview;
	NSMutableArray		*subviews;

	MORect				frame;
	MORect				bounds;

	MOGraphicsContext	*graphicsContext;
}

- (id)initWithFrame:(MORect)aFrame screen:(MOScreen *)aScreen;

- (MOScreen *)screen;
- (MOView *)superview;
- (NSMutableArray *)subviews;
- (void)addSubview:(MOView *)aSubview;

- (MOPoint)convertPointFromScreen:(MOPoint)aPoint;
- (MOPoint)convertPointToScreen:(MOPoint)aPoint;

- (MOView *)subviewAtPoint:(MOPoint)aPoint;
- (MOView *)deepestSubviewAtPoint:(MOPoint)aPoint;

- (MORect)frame;
- (MORect)bounds;

- (void)lockFocus;
- (void)unlockFocus;

- (void)display;
- (void)drawRect:(MORect)aRect;

- (BOOL)keyDown:(MOEvent *)aEvent;
- (BOOL)keyUp:(MOEvent *)aEvent;
- (void)mouseDown:(MOEvent *)aEvent;
- (void)mouseUp:(MOEvent *)aEvent;
- (void)mouseDragged:(MOEvent *)aEvent;

@end
