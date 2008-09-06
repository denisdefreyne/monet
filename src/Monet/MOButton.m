#import <Monet/MOButton.h>

@implementation MOButton

// TODO track mouse enters/exits

- (id)initWithFrame:(MORect)aFrame screen:(MOScreen *)aScreen
{
	if(self = [super initWithFrame:aFrame screen:aScreen])
	{
		isMouseDown		= NO;
		isMouseInside	= NO;
	}

	return self;
}

#pragma mark -

- (BOOL)isPressed
{
	//return (isMouseDown && isMouseInside);
	return isMouseDown;
}

- (void)buttonClicked
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
	isMouseDown = NO;
}

@end
