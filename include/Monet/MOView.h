#import <Foundation/Foundation.h>

#import <Monet/MORect.h>

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

- (id)initWithFrame:(MORect)aFrame;

- (MOScreen *)screen;
- (void)setScreen:(MOScreen *)aScreen;
- (MOView *)superview;
- (NSMutableArray *)subviews;
- (void)addSubview:(MOView *)aSubview;

- (MOPoint)convertPointFromScreen:(MOPoint)aPoint;
- (MOPoint)convertPointToScreen:(MOPoint)aPoint;

- (MORect)frame;
- (MORect)bounds;

- (void)lockFocus;
- (void)unlockFocus;

- (void)display;
- (void)drawRect:(MORect)aRect;

@end
