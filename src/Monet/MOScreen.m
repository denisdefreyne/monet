#import <Monet/MOScreen.h>

#import <Monet/MOSpeedCounter.h>
#import <Monet/MOView.h>

@implementation MOScreen

- (void)dealloc
{
	SDL_FreeSurface(surface);
	SDL_Quit();

	[self setContentView:nil];
	[fpsCounter release];

	[super dealloc];
}

#pragma mark -

- (MOView *)contentView
{
	return contentView;
}

- (void)setContentView:(MOView *)aContentView
{
	[aContentView retain];
	[contentView release];
	contentView = aContentView;
}

- (MOSize)size
{
	return size;
}

- (void)setSize:(MOSize)aSize
{
	size = aSize;
}

#pragma mark -

- (void)open
{
	// Initialize SDL
	if(SDL_Init(SDL_INIT_EVERYTHING) < 0)
		[NSException raise:@"SDLException" format:@"SDL_Init failed: %s\n", SDL_GetError()];
	atexit(&SDL_Quit);

	// Create screen
	surface = SDL_SetVideoMode(size.w, size.h, 32, SDL_SWSURFACE);
	if(!surface)
		[NSException raise:@"SDLException" format:@"SDL_SetVideoMode failed: %s\n", SDL_GetError()];

	// We're open!
	isOpen = YES;
}

#define TICKS_PER_SECOND	(30)
#define MAX_FRAMESKIP		(5)

#define TICK_LENGTH			(1000/TICKS_PER_SECOND)

- (void)enterRunloop
{
	// Create update and draw FPS counters
	MOSpeedCounter *updateSpeedCounter	= [[MOSpeedCounter alloc] init];
	MOSpeedCounter *drawSpeedCounter	= [[MOSpeedCounter alloc] init];

	Uint32 nextTick = SDL_GetTicks();
	while(isOpen)
	{
		int iteration;
		for(iteration = 0; SDL_GetTicks() > nextTick && iteration < MAX_FRAMESKIP; ++iteration)
		{
			// Check events
			SDL_Event event;
			while(SDL_PollEvent(&event))
			{
				switch(event.type)
				{
					case SDL_ACTIVEEVENT:
						if(event.active.gain)
							; // Resume
						else
							; // Pause
						break;

					case SDL_KEYDOWN:
						[self close];
						break;

					case SDL_KEYUP:
						break;

					case SDL_MOUSEMOTION:
						break;

					case SDL_MOUSEBUTTONDOWN:
						break;

					case SDL_MOUSEBUTTONUP:
						break;

					case SDL_QUIT:
						[self close];
						break;
				}
			}

			// Update game
			[self update];

			// Update FPS
			[updateSpeedCounter tick];
			if([updateSpeedCounter isAtNewSecond])
				printf("[speed update]    %u\n", [updateSpeedCounter ticksPerSecond]);

			nextTick += TICK_LENGTH;
		}

		// Redraw
		[contentView display];
		SDL_Flip(surface);

		// Update FPS
		[drawSpeedCounter tick];
		if([drawSpeedCounter isAtNewSecond])
			printf("[speed draw]   %u\n", [drawSpeedCounter ticksPerSecond]);
	}
}

- (void)close
{
	isOpen = NO;
}

#pragma mark -

- (void)update
{
	// Do nothing by default
}

@end
