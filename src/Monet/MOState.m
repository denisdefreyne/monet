#import <Monet/MOState.h>

#import <Monet/MOApplication.h>
#import <Monet/MORect.h>
#import <Monet/MOView.h>

struct MOStateData
{
	NSObject <MOTicking> *world;
	MOView *view;
};

// FIXME view struct definition here is UGLY
#include <cobject/cobject.h>
struct _MOView
{
	COGuts                 *guts;

	MOApplication          *application;

	MOView                *superview;
	SBArray                *subviews;

	MORect                 frame;
	MORect                 bounds;

	// more irrelevant stuff here
};

@implementation MOState

+ (Class)viewClass
{
	return Nil;
}

#pragma mark -

- (id)initWithApp: (MOApplication *)aApp view: (MOView *)aView
{
	if ((self = [super init]))
	{
		stateData = calloc(1, sizeof (struct MOStateData));

		MOSize screenSize =  MOApplicationGetScreenSize(aApp);
		MORect frame = MORectMake(0, 0, screenSize.w, screenSize.h);
		// FIXME modifying view is ugly
		aView->application   = aApp;
		aView->frame = frame;
		aView->bounds = frame;
		aView->bounds.x = 0;
		aView->bounds.y = 0;
		stateData->view = CORetain(aView);
	}

	return self;
}

- (void)dealloc
{
	CORelease(stateData->view);
	free(stateData);

	[super dealloc];
}

#pragma mark -

- (NSObject <MOTicking> *)world
{
	return stateData->world;
}

- (void)setWorld: (NSObject <MOTicking> *)aWorld
{
	[aWorld retain];
	[stateData->world release];
	stateData->world = aWorld;
}

- (MOView *)view
{
	return stateData->view;
}

#pragma mark -

- (void)tick: (double)aSeconds
{
	[stateData->world tick: aSeconds];
	MOViewTick(stateData->view, aSeconds);
}

@end
