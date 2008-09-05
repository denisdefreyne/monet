#import <Monet/MOScreen.h>

#import <Foundation/Foundation.h>

#import <Monet/MOEvent.h>
#import <Monet/MOSpeedCounter.h>
#import <Monet/MOView.h>
#import <Monet/Private.h>

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

- (BOOL)isFullscreen
{
	return isFullscreen;
}

- (void)setFullscreen:(BOOL)aIsFullscreen
{
	isFullscreen = aIsFullscreen;
}

#pragma mark -

- (void)open
{
	// Initialize SDL
	if(SDL_Init(SDL_INIT_VIDEO) < 0)
		[NSException raise:@"SDLException" format:@"SDL_Init failed: %s\n", SDL_GetError()];
	atexit(&SDL_Quit);

	// Create screen
	Uint32 flags = SDL_SWSURFACE | SDL_HWACCEL | SDL_ASYNCBLIT | SDL_RLEACCEL | (isFullscreen ? SDL_FULLSCREEN : 0);
	if(SDL_VideoModeOK(size.w, size.h, 32, flags))
		surface = SDL_SetVideoMode(size.w, size.h, 32, flags);
	else
	{
		NSLog(@"Falling back to software surface");
		surface = SDL_SetVideoMode(size.w, size.h, 32, SDL_SWSURFACE);
		if(!surface)
			[NSException raise:@"SDLException" format:@"SDL_SetVideoMode failed: %s\n", SDL_GetError()];
	}

	// Ignore unused events
	SDL_EventState(SDL_JOYAXISMOTION,	SDL_IGNORE);
	SDL_EventState(SDL_JOYBALLMOTION,	SDL_IGNORE);
	SDL_EventState(SDL_JOYHATMOTION,	SDL_IGNORE);
	SDL_EventState(SDL_JOYBUTTONDOWN,	SDL_IGNORE);
	SDL_EventState(SDL_JOYBUTTONUP,		SDL_IGNORE);
	SDL_EventState(SDL_SYSWMEVENT,		SDL_IGNORE);
	SDL_EventState(SDL_VIDEORESIZE,		SDL_IGNORE);
	SDL_EventState(SDL_VIDEOEXPOSE,		SDL_IGNORE);

	// Make sure key down event have unicode
	SDL_EnableUNICODE(1);

	// We're open!
	isOpen = YES;

	// Notify
	[self screenDidLoad];
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
						if(event.key.keysym.sym == SDLK_ESCAPE)
							[self close];
						else
						{
							// Get character
							NSString *character;
							if(event.key.keysym.unicode == 0)
								character = @"";
							else
								character = [[NSString alloc] initWithCharacters:&event.key.keysym.unicode length:1];

							// Create event
							MOEvent *moEvent = [[MOEvent alloc] initKeyEventWithType:MOKeyDownEventType
																modifiers:MOSDLModToMOKeyModifierMask(event.key.keysym.mod)
																character:character
																key:MOSDLKeyToMOKey(event.key.keysym.sym)
							];

							// Dispatch event
							[contentView keyDown:moEvent];

							// Cleanup
							[character release];
							[moEvent release];
						}
						break;

					case SDL_KEYUP:
						{
							// Create event
							MOEvent *moEvent = [[MOEvent alloc] initKeyEventWithType:MOKeyUpEventType
																modifiers:MOSDLModToMOKeyModifierMask(event.key.keysym.mod)
																character:0
																key:MOSDLKeyToMOKey(event.key.keysym.sym)
							];

							// Dispatch event
							[contentView keyUp:moEvent];

							// Cleanup
							[moEvent release];
						}
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

- (void)screenDidLoad
{
	// Do nothing by default
}

- (void)update
{
	// Do nothing by default
}

@end
