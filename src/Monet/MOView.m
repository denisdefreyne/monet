#import <Monet/MOView.h>

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

- (MORect)frame
{
	return frame;
}

- (MORect)bounds
{
	return bounds;
}

#pragma mark -

- (void)lockFocus
{
	if(!graphicsContext)
	{
		// Get surface
		SDL_Surface *surface = [[self screen] surface];

		// Get clipping rectangle
		MOPoint absoluteOrigin = [self absoluteOrigin];
		MORect rect = MOMakeRect(absoluteOrigin.x, absoluteOrigin.y, frame.w, frame.h);

		// Create graphics context
		graphicsContext = [[MOGraphicsContext alloc] initWithSurface:surface rect:rect];
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

- (void)drawRect:(MORect)aRect
{
	// Do nothing by default
}

@end
