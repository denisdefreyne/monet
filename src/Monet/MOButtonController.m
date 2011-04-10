#import <Monet/MOButtonController.h>

#import <Monet/MOApplication.h>
#import <Monet/MOPoint.h>
#import <Monet/MORect.h>
#import <Monet/MOView.h>

struct MOButtonControllerData
{
	BOOL isMouseDown;
	BOOL isMouseInside;
};

@implementation MOButtonController : MOController

- (id)initWithView: (MOView *)aView
{
	if ((self = [super initWithView: aView]))
	{
		buttonControllerData = calloc(1, sizeof (struct MOButtonControllerData));
		buttonControllerData->isMouseDown   = NO;
		buttonControllerData->isMouseInside = NO;
	}

	return self;
}

#pragma mark -

- (BOOL)isPressed
{
	return buttonControllerData->isMouseDown && MORectContainsPoint(
		[[self view] bounds],
		[[self view] convertPointFromScreen: [[self app] mouseLocation]]);
}

#pragma mark -

- (void)mouseDown: (MOEvent *)aEvent
{
	buttonControllerData->isMouseDown = YES;
}

- (void)mouseUp: (MOEvent *)aEvent
{
	if ([self isPressed])
		[self clicked];

	buttonControllerData->isMouseDown = NO;
}

#pragma mark -

- (void)clicked
{
	;
}

@end
