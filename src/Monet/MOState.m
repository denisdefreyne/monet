#import <Monet/MOState.h>

struct MOStateData
{
	MOView *view;
};

@implementation MOState

+ (Class)viewClass
{
	return Nil;
}

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

- (MOView *)view
{
	return stateData->view;
}

- (MOController *)controller
{
	return [stateData->view controller];
}

@end
