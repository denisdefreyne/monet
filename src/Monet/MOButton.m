#import <Monet/MOButton.h>

#import <Monet/MOApplication.h>
#import <Monet/MOPoint.h>
#import <Monet/MORect.h>
#import <Monet/MOView.h>

struct MOButtonData
{
	BOOL isMouseDown;
	BOOL isMouseInside;
};

@implementation MOButton : MOView

- (id)initWithFrame: (MORect)aFrame app: (MOApplication *)aApp;
{
	if ((self = [super initWithFrame: aFrame app: aApp]))
	{
		buttonData = calloc(1, sizeof (struct MOButtonData));
		buttonData->isMouseDown   = NO;
		buttonData->isMouseInside = NO;
	}

	return self;
}

#pragma mark -

- (BOOL)isPressed
{
	return buttonData->isMouseDown && MORectContainsPoint(
		[self bounds],
		[self convertPointFromScreen: [[self app] mouseLocation]]);
}

#pragma mark -

- (void)mouseDown: (MOEvent *)aEvent
{
	buttonData->isMouseDown = YES;
}

- (void)mouseUp: (MOEvent *)aEvent
{
	if ([self isPressed])
		[self clicked];

	buttonData->isMouseDown = NO;
}

#pragma mark -

- (void)clicked
{
	;
}

@end
