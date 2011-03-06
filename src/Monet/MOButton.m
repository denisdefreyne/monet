#import <Monet/MOButton.h>

#import <Monet/MOApplication.h>

struct MOButtonData
{
	BOOL isMouseDown;
	BOOL isMouseInside;
};

@implementation MOButton

- (id)initWithFrame: (MORect)aFrame app: (MOApplication *)aApp
{
	if (self = [super initWithFrame: aFrame app: aApp])
	{
		// Create data
		buttonData = calloc(1, sizeof (struct MOButtonData));

		// Set default values
		buttonData->isMouseDown   = NO;
		buttonData->isMouseInside = NO;
	}

	return self;
}

#pragma mark -

- (BOOL)isPressed
{
	return buttonData->isMouseDown && MORectContainsPoint([self bounds], [self convertPointFromScreen: [[self app] mouseLocation]]);
}

- (void)clicked
{
	// Do nothing by default
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

@end
