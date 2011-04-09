#import <Monet/MOState.h>

struct MOStateData
{
	NSObject <MOTicking> *world;
	MOView *view;
};

@implementation MOState

+ (Class)viewClass
{
	return Nil;
}

#pragma mark -

- (id)initWithApp: (MOApplication *)aApp
{
	if ((self = [super init]))
	{
		stateData = calloc(1, sizeof (struct MOStateData));

		Class viewClass = [[self class] viewClass];
		MORect frame = MORectMake(0, 0, [aApp screenSize].w, [aApp screenSize].h);
		stateData->view = [[viewClass alloc] initWithFrame: frame app: aApp];
	}

	return self;
}

- (void)dealloc
{
	[stateData->view release];
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

- (MOController *)controller
{
	return [stateData->view controller];
}

#pragma mark -

- (void)tick: (double)aSeconds
{
	[stateData->world tick: aSeconds];
	[[self controller] tick: aSeconds];
}

@end
