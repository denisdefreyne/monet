#import <Monet/MOView.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import <Monet/MOEvent.h>
#import <Monet/MOApplication.h>
#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

struct MOViewData
{
	MOApplication		*app;

	MOView				*superview;
	NSMutableArray		*subviews;

	MORect				frame;
	MORect				bounds;

	MOGraphicsContext	*graphicsContext;
};

@implementation MOView

- (id)initWithFrame:(MORect)aFrame app:(MOApplication *)aApp
{
	if(self = [super init])
	{
		viewData = calloc(1, sizeof (struct MOViewData));

		viewData->frame = aFrame;

		viewData->app = aApp;

		viewData->bounds.w = viewData->frame.w;
		viewData->bounds.h = viewData->frame.h;

		viewData->subviews = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void)dealloc
{
	[viewData->subviews release];

	[viewData->graphicsContext release];

	[super dealloc];
}

#pragma mark -

- (MOApplication *)app
{
	if(!viewData->app)
		viewData->app = [viewData->superview app];

	return viewData->app;
}

- (MOView *)superview
{
	return viewData->superview;
}

- (void)setSuperview:(MOView *)aSuperview
{
	// Don't retain
	viewData->superview = aSuperview;
}

- (NSMutableArray *)subviews
{
	return viewData->subviews;
}

- (void)addSubview:(MOView *)aSubview
{
	[viewData->subviews addObject:aSubview];
	[aSubview setSuperview:self];
}

#pragma mark -

- (MOPoint)absoluteOrigin
{
	return [viewData->superview convertPointToScreen:MOPointMake(viewData->frame.x, viewData->frame.y)];
}

- (MOPoint)convertPointFromScreen:(MOPoint)aPoint
{
	if(!viewData->superview)
		return aPoint;
	else
	{
		MOPoint absoluteOrigin = [self absoluteOrigin];
		return MOPointMake(aPoint.x - absoluteOrigin.x, aPoint.y - absoluteOrigin.y);
	}
}

- (MOPoint)convertPointToScreen:(MOPoint)aPoint
{
	if(!viewData->superview)
		return aPoint;
	else
	{
		MOPoint absoluteOrigin = [self absoluteOrigin];
		return MOPointMake(aPoint.x + absoluteOrigin.x, aPoint.y + absoluteOrigin.y);
	}
}

#pragma mark -

// aPoint is relative to the screen here, not the view.
- (MOView *)subviewAtPoint:(MOPoint)aPoint
{
	NSEnumerator *enumerator = [viewData->subviews objectEnumerator];
	MOView *subview = nil;
	while(subview = [enumerator nextObject])
	{
		if(MORectContainsPoint([subview bounds], [subview convertPointFromScreen:aPoint]))
			return subview;
	}

	return nil;
}

// aPoint is relative to the screen here, not the view.
- (MOView *)deepestSubviewAtPoint:(MOPoint)aPoint
{
	// Find deepest subview
	MOView *subview = self;
	while(YES)
	{
		MOView *newSubview = [subview subviewAtPoint:aPoint];
		if(newSubview)
			subview = newSubview;
		else
			break;
	}

	return subview;
}

#pragma mark -

- (MORect)frame
{
	return viewData->frame;
}

- (MORect)bounds
{
	return viewData->bounds;
}

- (MORect)boundsRelativeToWindow
{
	MOPoint absoluteOrigin = [self absoluteOrigin];
	return MORectMake(absoluteOrigin.x, absoluteOrigin.y, viewData->bounds.w, viewData->bounds.h);
}

#pragma mark -

- (void)lockFocus
{
	if(!viewData->graphicsContext)
	{
		// Get destination rectangle
		MOPoint absoluteOrigin = [self absoluteOrigin];
		MORect rect = MORectMake(absoluteOrigin.x, absoluteOrigin.y, viewData->frame.w, viewData->frame.h);

		// Create graphics context
		viewData->graphicsContext = [[MOGraphicsContext alloc] initWithRect:rect];
	}

	[[MOGraphicsContext stack] addObject:viewData->graphicsContext];
}

- (void)unlockFocus
{
	[[MOGraphicsContext stack] removeLastObject];
}

#pragma mark -

- (void)display
{
	// Set up clipping
	glScissor([self absoluteOrigin].x, [self absoluteOrigin].y, viewData->bounds.w, viewData->bounds.h);

	// Draw this view
	[self lockFocus];
	[self drawRect:[self bounds]];
	[self unlockFocus];

	// Draw subviews
	NSEnumerator *enumerator = [viewData->subviews objectEnumerator];
	MOView *subview = nil;
	while(subview = [enumerator nextObject])
		[subview display];
}

- (void)clear
{
	glClear(GL_COLOR_BUFFER_BIT);
}

- (void)drawRect:(MORect)aRect
{
	// Do nothing by default
}

#pragma mark -

- (BOOL)keyDown:(MOEvent *)aEvent
{
	NSEnumerator *enumerator = [viewData->subviews objectEnumerator];
	MOView *subview = nil;
	BOOL isHandled = NO;
	while(subview = [enumerator nextObject])
	{
		isHandled = [subview keyDown:aEvent];
		if(isHandled)
			break;
	}

	return isHandled;
}

- (BOOL)keyUp:(MOEvent *)aEvent
{
	NSEnumerator *enumerator = [viewData->subviews objectEnumerator];
	MOView *subview = nil;
	BOOL isHandled = NO;
	while(subview = [enumerator nextObject])
	{
		isHandled = [subview keyUp:aEvent];
		if(isHandled)
			break;
	}

	return isHandled;
}

- (void)mouseDown:(MOEvent *)aEvent
{
	[viewData->superview mouseDown:aEvent];
}

- (void)mouseUp:(MOEvent *)aEvent
{
	[viewData->superview mouseUp:aEvent];
}

- (void)mouseDragged:(MOEvent *)aEvent
{
	;
}

#pragma mark -

- (void)tick
{
	// Do nothing by default
}

@end
