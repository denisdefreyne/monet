#import <Monet/MOView.h>

#import <Monet/MOScreen.h>
#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

@implementation MOView

- (id)initWithFrame:(MORect)aFrame
{
	if(self = [super init])
	{
		frame = aFrame;

		bounds.origin = MOMakePoint(0, 0);
		bounds.size = frame.size;

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

- (void)setScreen:(MOScreen *)aScreen
{
	// Don't retain
	screen = aScreen;
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
	return [superview convertPointToScreen:frame.origin];
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
		MORect rect = MOMakeRect(absoluteOrigin.x, absoluteOrigin.y, frame.size.width, frame.size.height);

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
