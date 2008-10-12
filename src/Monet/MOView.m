#import <Monet/MOView.h>

#import <Monet/MOEvent.h>
#import <Monet/MOScreen.h>
#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

@implementation MOView

- (id)initWithFrame:(MORect)aFrame screen:(MOScreen *)aScreen
{
	if(self = [super init])
	{
		frame = aFrame;

		screen = aScreen;

		bounds.w = frame.w;
		bounds.h = frame.h;

		subviews = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void)dealloc
{
	[subviews release];

	[graphicsContext release];

	[super dealloc];
}

#pragma mark -

- (MOScreen *)screen
{
	if(!screen)
		screen = [superview screen];

	return screen;
}

- (MOView *)superview
{
	return superview;
}

- (void)setSuperview:(MOView *)aSuperview
{
	// Don't retain
	superview = aSuperview;
}

- (NSMutableArray *)subviews
{
	return subviews;
}

- (void)addSubview:(MOView *)aSubview
{
	[subviews addObject:aSubview];
	[aSubview setSuperview:self];
}

#pragma mark -

- (MOPoint)absoluteOrigin
{
	return [superview convertPointToScreen:MOMakePoint(frame.x, frame.y)];
}

- (MOPoint)convertPointFromScreen:(MOPoint)aPoint
{
	if(!superview)
		return aPoint;
	else
	{
		MOPoint absoluteOrigin = [self absoluteOrigin];
		return MOMakePoint(aPoint.x - absoluteOrigin.x, aPoint.y - absoluteOrigin.y);
	}
}

- (MOPoint)convertPointToScreen:(MOPoint)aPoint
{
	if(!superview)
		return aPoint;
	else
	{
		MOPoint absoluteOrigin = [self absoluteOrigin];
		return MOMakePoint(aPoint.x + absoluteOrigin.x, aPoint.y + absoluteOrigin.y);
	}
}

#pragma mark -

// aPoint is relative to the screen here, not the view.
- (MOView *)subviewAtPoint:(MOPoint)aPoint
{
	NSEnumerator *enumerator = [subviews objectEnumerator];
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
	return frame;
}

- (MORect)bounds
{
	return bounds;
}

- (MORect)boundsRelativeToWindow
{
	MOPoint absoluteOrigin = [self absoluteOrigin];
	return MOMakeRect(absoluteOrigin.x, absoluteOrigin.y, bounds.w, bounds.h);
}

#pragma mark -

- (void)lockFocus
{
	if(!graphicsContext)
	{
		// Get destination rectangle
		MOPoint absoluteOrigin = [self absoluteOrigin];
		MORect rect = MOMakeRect(absoluteOrigin.x, absoluteOrigin.y, frame.w, frame.h);

		// Create graphics context
		graphicsContext = [[MOGraphicsContext alloc] initWithRect:rect];
	}

	[[MOGraphicsContext stack] addObject:graphicsContext];
}

- (void)unlockFocus
{
	[[MOGraphicsContext stack] removeLastObject];
}

#pragma mark -

- (void)display
{
	// Set up clipping
	MORect scissorRect = MOMakeRect(
		[self absoluteOrigin].x,
		[[self screen] size].h - [self absoluteOrigin].y - bounds.h, // projection matrix is irrelevant
		bounds.w,
		bounds.h
	);
	glScissor(scissorRect.x, scissorRect.y, scissorRect.w, scissorRect.h);

	// Draw this view
	[self lockFocus];
	[self drawRect:[self bounds]];
	[self unlockFocus];

	// Draw subviews
	NSEnumerator *enumerator = [subviews objectEnumerator];
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
	NSEnumerator *enumerator = [subviews objectEnumerator];
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
	NSEnumerator *enumerator = [subviews objectEnumerator];
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
	[superview mouseDown:aEvent];
}

- (void)mouseUp:(MOEvent *)aEvent
{
	[superview mouseUp:aEvent];
}

- (void)mouseDragged:(MOEvent *)aEvent
{
	;
}

@end
