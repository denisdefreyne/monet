#import <Monet/MOController.h>

#import <Monet/MOApplication.h>
#import <Monet/MOEvent.h>
#import <Monet/MOView.h>

struct MOControllerData
{
	MOView *view;
};

@implementation MOController

- (id)initWithView: (MOView *)aView
{
	if ((self = [super init]))
	{
		controllerData = calloc(1, sizeof (struct MOControllerData));

		controllerData->view = aView;
	}

	return self;
}

#pragma mark -

- (MOApplication *)app
{
	return [controllerData->view app];
}

#pragma mark -

- (BOOL)keyDown: (MOEvent *)aEvent
{
	NSEnumerator *enumerator = [[controllerData->view subviews] objectEnumerator];
	MOView *subview = nil;
	BOOL isHandled = NO;
	while ((subview = [enumerator nextObject]))
	{
		isHandled = [[subview controller] keyDown: aEvent];
		if (isHandled)
			break;
	}

	return isHandled;
}

- (BOOL)keyUp: (MOEvent *)aEvent
{
	NSEnumerator *enumerator = [[controllerData->view subviews] objectEnumerator];
	MOView *subview = nil;
	BOOL isHandled = NO;
	while ((subview = [enumerator nextObject]))
	{
		isHandled = [[subview controller] keyUp: aEvent];
		if (isHandled)
			break;
	}

	return isHandled;
}

- (void)mouseDown: (MOEvent *)aEvent
{
	[[[controllerData->view superview] controller] mouseDown: aEvent];
}

- (void)mouseUp: (MOEvent *)aEvent
{
	[[[controllerData->view superview] controller] mouseUp: aEvent];
}

- (void)mouseDragged: (MOEvent *)aEvent
{
	;
}

#pragma mark -

- (void)tick
{
	// Do nothing by default
}

@end
