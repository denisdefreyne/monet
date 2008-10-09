#import <Monet/MOScreen.h>

#import <Foundation/Foundation.h>

#import <Monet/MOEvent.h>
#import <Monet/MOSpeedCounter.h>
#import <Monet/MOView.h>
#import <Monet/Private.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

@interface MOScreen (Autoreleasing)

- (void)refreshAutoreleasePool;

@end

@implementation MOScreen (Autoreleasing)

- (void)refreshAutoreleasePool
{
	[autoreleasePool release];
	autoreleasePool = [[NSAutoreleasePool alloc] init];
}

@end

@interface MOScreen (Runloop)

- (void)handleEvents;

@end

@implementation MOScreen (Runloop)

- (void)handleEvents
{
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
				{
					// Create event
					MOEvent *moEvent = [[MOEvent alloc] initMouseMotionEventWithModifiers:MOSDLModToMOKeyModifierMask(SDL_GetModState())
														mouseLocation:MOMakePoint(event.motion.x, event.motion.y)
														relativeMouseMotion:MOMakePoint(event.motion.xrel, event.motion.yrel)
					];

					// Dispatch event to subviews that want it
					if(lastLeftMouseButtonDownView)
						[lastLeftMouseButtonDownView mouseDragged:moEvent];
					if(lastMiddleMouseButtonDownView)
						[lastMiddleMouseButtonDownView mouseDragged:moEvent];
					if(lastRightMouseButtonDownView)
						[lastRightMouseButtonDownView mouseDragged:moEvent];

					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_MOUSEBUTTONDOWN:
				{
					// Get event information
					MOPoint mouseLocation		= MOMakePoint(event.button.x, event.button.y);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					UInt8 modifiers				= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find deepest subview
					MOView *subview = [contentView deepestSubviewAtPoint:mouseLocation];

					// Set last view receiving event
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							lastLeftMouseButtonDownView = subview;
							break;

						case MOMiddleMouseButton:
							lastMiddleMouseButtonDownView = subview;
							break;

						case MORightMouseButton:
							lastRightMouseButtonDownView = subview;
							break;
					}

					// Create event
					MOEvent *moEvent = [[MOEvent alloc] initMouseButtonEventWithType:MOMouseButtonDownEventType
														modifiers:modifiers
														mouseButton:mouseButton
														mouseLocation:mouseLocation
														clickCount:1 // FIXME set correct click count
					];

					// Dispatch event
					[subview mouseDown:moEvent];

					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_MOUSEBUTTONUP:
				{
					// Get event information
					MOPoint mouseLocation		= MOMakePoint(event.button.x, event.button.y);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					UInt8 modifiers				= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find subview
					MOView *subview = nil;
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							subview = lastLeftMouseButtonDownView;
							break;

						case MOMiddleMouseButton:
							subview = lastMiddleMouseButtonDownView;
							break;

						case MORightMouseButton:
							subview = lastRightMouseButtonDownView;
							break;
					}

					// Create event
					MOEvent *moEvent = [[MOEvent alloc] initMouseButtonEventWithType:MOMouseButtonUpEventType
														modifiers:modifiers
														mouseButton:mouseButton
														mouseLocation:mouseLocation
														clickCount:1 // FIXME set correct click count
					];

					// Dispatch event
					[subview mouseUp:moEvent];

					// Clear relevant subview
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							lastLeftMouseButtonDownView = nil;
							break;

						case MOMiddleMouseButton:
							lastMiddleMouseButtonDownView = nil;
							break;

						case MORightMouseButton:
							lastRightMouseButtonDownView = nil;
							break;
					}


					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_QUIT:
				[self close];
				break;
		}
	}
}

@end

@implementation MOScreen

- (id)init
{
	if(self = [super init])
	{
		gameTicksPerSecond		= 30;
	}

	return self;
}

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

- (UInt8)gameTicksPerSecond
{
	return gameTicksPerSecond;
}

- (void)setGameTicksPerSecond:(UInt8)aGameTicksPerSecond
{
	gameTicksPerSecond = aGameTicksPerSecond;
}

#pragma mark -

- (void)open
{
	// Setup autorelease pool
	[self refreshAutoreleasePool];

	// Initialize SDL
	if(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0)
		[NSException raise:@"SDLException" format:@"SDL_Init failed: %s\n", SDL_GetError()];
	atexit(&SDL_Quit);

	// Setup OpenGL attributes
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

	// Create screen
	Uint32 flags = SDL_OPENGL | (isFullscreen ? SDL_FULLSCREEN : 0);
	surface = SDL_SetVideoMode(size.w, size.h, 0, flags);
	if(!surface)
		[NSException raise:@"SDLException" format:@"SDL_SetVideoMode failed: %s\n", SDL_GetError()];

	// Optimize for 2D drawing
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);
	glDisable(GL_LIGHTING);

	// Set up texturing
	//glEnable(GL_TEXTURE_2D);
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	if(!gluCheckExtension("GL_EXT_texture_rectangle", glGetString(GL_EXTENSIONS)))
		[NSException raise:@"OpenGLException" format:@"Unsupported extension: GL_EXT_texture_rectangle"];

	// Set clear color
	glClearColor(0.0, 0.0, 0.0, 0.0);

	// Enable blending
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// Enable clipping
	glEnable(GL_SCISSOR_TEST);

	// Set projection matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0, surface->w, surface->h, 0); // origin in top left corner

	// Set modelview matrix
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

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

#define MAX_FRAMESKIP		(5)

- (void)enterRunloop
{
	// Create game and draw FPS counters
	MOSpeedCounter *gameSpeedCounter	= [[MOSpeedCounter alloc] init];
	MOSpeedCounter *drawSpeedCounter	= [[MOSpeedCounter alloc] init];

	Uint32	gameTickLength		= 1000/gameTicksPerSecond;
	Uint32	nextGameTick		= SDL_GetTicks();

	while(isOpen)
	{
		for(int i = 0; SDL_GetTicks() > nextGameTick && i < MAX_FRAMESKIP; ++i)
		{
			// Update game
			[self update];

			// Record speed
			[gameSpeedCounter tick];

			nextGameTick += gameTickLength;
		}

		// Handle events
		[self handleEvents];

		// Redraw
		glClear(GL_COLOR_BUFFER_BIT);
		[contentView display];
		SDL_GL_SwapBuffers();

		// Record speed
		[drawSpeedCounter tick];

		// Show speeds
		if([drawSpeedCounter isAtNewSecond])
			printf(
				"[speed] game=%u  draw=%u\n",
				[gameSpeedCounter ticksPerSecond],
				[drawSpeedCounter ticksPerSecond]
			);

		// Empty autorelease pool
		[self refreshAutoreleasePool];
	}
}

- (void)close
{
	isOpen = NO;
}

#pragma mark -

- (MOPoint)mouseLocation
{
	int x,y;
	SDL_GetMouseState(&x, &y);

	return MOMakePoint(x, y);
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
