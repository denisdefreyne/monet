#import <Monet/MOButton.h>

#import <Monet/MOApplication.h>

@implementation MOButton

- (id)initWithFrame:(MORect)aFrame app:(MOApplication *)aApp
{
	if(self = [super initWithFrame:aFrame app:aApp])
	{
		isMouseDown		= NO;
		isMouseInside	= NO;
	}

	return self;
}

#pragma mark -

- (BOOL)isPressed
{
	return isMouseDown && MORectContainsPoint([self bounds], [self convertPointFromScreen:[[self app] mouseLocation]]);
}

- (void)clicked
{
	// Do nothing by default
}

#pragma mark -

- (void)mouseDown:(MOEvent *)aEvent
{
	isMouseDown = YES;
}

- (void)mouseUp:(MOEvent *)aEvent
{
	if([self isPressed])
		[self clicked];

	isMouseDown = NO;
}

@end
