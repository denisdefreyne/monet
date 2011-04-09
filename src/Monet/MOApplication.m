#import <Monet/MOApplication.h>

#import <Foundation/Foundation.h>

#import <Monet/MOEvent.h>
#import <Monet/MOView.h>
#import <Monet/Private.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import <SDL_mixer.h>

struct MOApplicationData
{
	// Pool
	NSAutoreleasePool *autoreleasePool;

	// Surface
	SDL_Surface       *surface;
	MOSize            screenSize;
	BOOL              isFullscreen;

	// Running or not?
	BOOL              isOpen;

	// View etc
	NSMutableArray    *stateStack;

	// Timing
	uint8_t           maxFrameSkip;
	uint8_t           gameTicksPerSecond;
	float             interpolation;

	// Recent views receiving mouse button events
	MOView            *lastLeftMouseButtonDownView;
	MOView            *lastMiddleMouseButtonDownView;
	MOView            *lastRightMouseButtonDownView;
};

@interface MOApplication (Autoreleasing)

- (void)refreshAutoreleasePool;

@end

@implementation MOApplication (Autoreleasing)

- (void)refreshAutoreleasePool
{
	[applicationData->autoreleasePool release];
	applicationData->autoreleasePool = [[NSAutoreleasePool alloc] init];
}

@end

@interface MOApplication (Runloop)

- (void)handleEvents;

@end

@implementation MOApplication (Runloop)

- (void)handleEvents
{
	SDL_Event event;
	while (SDL_PollEvent(&event))
	{
		switch(event.type)
		{
			case SDL_ACTIVEEVENT:
				if (event.active.gain)
					; // Resume
				else
					; // Pause
				break;

			case SDL_KEYDOWN:
				{
					// Get character
					NSString *character;
					if (event.key.keysym.unicode == 0)
						character = @"";
					else
						character = [[NSString alloc] initWithCharacters: &event.key.keysym.unicode length: 1];

					// Create event
					MOEvent *moEvent = [[MOEvent alloc]
						initKeyEventWithType: MOKeyDownEventType
						modifiers: MOSDLModToMOKeyModifierMask(event.key.keysym.mod)
						character: character
						key: MOSDLKeyToMOKey(event.key.keysym.sym)
					];

					// Dispatch event
					[[[self currentState] controller] keyDown: moEvent];

					// Cleanup
					[character release];
					[moEvent release];
				}
				break;

			case SDL_KEYUP:
				{
					// Create event
					MOEvent *moEvent = [[MOEvent alloc]
						initKeyEventWithType: MOKeyUpEventType
						modifiers: MOSDLModToMOKeyModifierMask(event.key.keysym.mod)
						character: 0
						key: MOSDLKeyToMOKey(event.key.keysym.sym)
					];

					// Dispatch event
					[[[self currentState] controller] keyUp: moEvent];

					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_MOUSEMOTION:
				{
					// Create event
					MOEvent *moEvent = [[MOEvent alloc]
						initMouseMotionEventWithModifiers: MOSDLModToMOKeyModifierMask(SDL_GetModState())
						mouseLocation: MOPointMake(event.motion.x, applicationData->screenSize.h-event.motion.y-1)
						relativeMouseMotion: MOPointMake(event.motion.xrel, event.motion.yrel)
					];

					// Dispatch event to subviews that want it
					if (applicationData->lastLeftMouseButtonDownView)
						[[applicationData->lastLeftMouseButtonDownView controller] mouseDragged: moEvent];
					if (applicationData->lastMiddleMouseButtonDownView)
						[[applicationData->lastMiddleMouseButtonDownView controller] mouseDragged: moEvent];
					if (applicationData->lastRightMouseButtonDownView)
						[[applicationData->lastRightMouseButtonDownView controller] mouseDragged: moEvent];

					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_MOUSEBUTTONDOWN:
				{
					// Get event information
					MOPoint mouseLocation		= MOPointMake(
						event.button.x,
						applicationData->screenSize.h-event.button.y-1);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					uint8_t modifiers			= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find deepest subview
					MOView *subview = [[[self currentState] view] deepestSubviewAtPoint: mouseLocation];

					// Set last view receiving event
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							applicationData->lastLeftMouseButtonDownView = subview;
							break;

						case MOMiddleMouseButton:
							applicationData->lastMiddleMouseButtonDownView = subview;
							break;

						case MORightMouseButton:
							applicationData->lastRightMouseButtonDownView = subview;
							break;
					}

					// Create event
					MOEvent *moEvent = [[MOEvent alloc]
						initMouseButtonEventWithType:MOMouseButtonDownEventType
						modifiers:modifiers
						mouseButton:mouseButton
						mouseLocation:mouseLocation
						clickCount:1 // FIXME set correct click count
					];

					// Dispatch event
					[[subview controller] mouseDown: moEvent];

					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_MOUSEBUTTONUP:
				{
					// Get event information
					MOPoint mouseLocation		= MOPointMake(
						event.button.x,
						applicationData->screenSize.h-event.button.y-1);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					uint8_t modifiers			= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find subview
					// FIXME won’t work well if game state is different
					MOView *subview = nil;
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							subview = applicationData->lastLeftMouseButtonDownView;
							break;

						case MOMiddleMouseButton:
							subview = applicationData->lastMiddleMouseButtonDownView;
							break;

						case MORightMouseButton:
							subview = applicationData->lastRightMouseButtonDownView;
							break;
					}

					// Create event
					MOEvent *moEvent = [[MOEvent alloc]
						initMouseButtonEventWithType:MOMouseButtonUpEventType
						modifiers:modifiers
						mouseButton:mouseButton
						mouseLocation:mouseLocation
						clickCount:1 // FIXME set correct click count
					];

					// Dispatch event
					[[subview controller] mouseUp: moEvent];

					// Clear relevant subview
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							applicationData->lastLeftMouseButtonDownView = nil;
							break;

						case MOMiddleMouseButton:
							applicationData->lastMiddleMouseButtonDownView = nil;
							break;

						case MORightMouseButton:
							applicationData->lastRightMouseButtonDownView = nil;
							break;
					}


					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_USEREVENT:
				{
					MOTimer *timer = event.user.data1;
					MOEvent *moEvent = [[MOEvent alloc] initTimerEventWithTimer: timer];
					[[[self currentState] controller] timerFired: moEvent];
				}
				break;

			case SDL_QUIT:
				[self closeScreen];
				break;
		}
	}
}

@end

@implementation MOApplication

- (id)init
{
	if ((self = [super init]))
	{
		// Create data
		applicationData = calloc(1, sizeof (struct MOApplicationData));

		// Init stack
		applicationData->stateStack = [[[NSMutableArray alloc] init] autorelease];

		// Set default values
		applicationData->gameTicksPerSecond = 30;
		applicationData->maxFrameSkip       = 3;
	}

	return self;
}

- (void)dealloc
{
	[applicationData->stateStack release];
	SDL_FreeSurface(applicationData->surface);
	SDL_Quit();

	[super dealloc];
}

#pragma mark -

- (MOSize)screenSize
{
	return applicationData->screenSize;
}

- (void)setScreenSize: (MOSize)aScreenSize
{
	applicationData->screenSize = aScreenSize;
}

- (BOOL)isFullscreen
{
	return applicationData->isFullscreen;
}

- (void)setFullscreen: (BOOL)aIsFullscreen
{
	applicationData->isFullscreen = aIsFullscreen;
}

- (uint8_t)gameTicksPerSecond
{
	return applicationData->gameTicksPerSecond;
}

- (void)setGameTicksPerSecond: (uint8_t)aGameTicksPerSecond
{
	applicationData->gameTicksPerSecond = aGameTicksPerSecond;
}

- (uint8_t)maxFrameSkip
{
	return applicationData->maxFrameSkip;
}

- (void)setMaxFrameSkip: (uint8_t)aMaxFrameSkip
{
	applicationData->maxFrameSkip = aMaxFrameSkip;
}

#pragma mark -

- (void)openScreen
{
	// Setup autorelease pool
	[self refreshAutoreleasePool];

	// Initialize SDL
	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_AUDIO) < 0)
		[NSException raise: @"SDLException" format: @"SDL_Init failed: %s\n", SDL_GetError()];
	atexit(&SDL_Quit);

	// Setup OpenGL attributes
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
	SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 4);

	// Set up audio
	Mix_Init(0);
	if (Mix_OpenAudio(22050, AUDIO_S16, 2, 4096) < 0)
	{
		[NSException raise: @"SDLException" format: @"Mix_OpenAudio failed\n"];
		exit(1);
	}
	Mix_AllocateChannels(32);

	// Create screen
	Uint32 flags = SDL_OPENGL | (applicationData->isFullscreen ? SDL_FULLSCREEN : 0);
	applicationData->surface = SDL_SetVideoMode(applicationData->screenSize.w, applicationData->screenSize.h, 0, flags);
	if (!applicationData->surface)
		[NSException raise: @"SDLException" format: @"SDL_SetVideoMode failed: %s\n", SDL_GetError()];

	// Set up texturing
	if (!gluCheckExtension("GL_EXT_texture_rectangle", glGetString(GL_EXTENSIONS)))
		[NSException raise: @"OpenGLException" format: @"Unsupported extension: GL_EXT_texture_rectangle"];
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

	// Set clear color
	glClearColor(0.0, 0.0, 0.0, 0.0);

	// Enable multisampling
	glEnable(GL_MULTISAMPLE);

	// Enable blending
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// Enable clipping
	glEnable(GL_SCISSOR_TEST);

	// Set projection matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0, applicationData->surface->w, 0, applicationData->surface->h);

	// Set worldview matrix
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
	applicationData->isOpen = YES;
}

- (void)enterRunloop
{
	Uint32 gameTickLength          = 1000/applicationData->gameTicksPerSecond;
	double gameTickLengthInSeconds = 1.0/(double)applicationData->gameTicksPerSecond;
	Uint32 nextGameTick            = SDL_GetTicks();

	while (applicationData->isOpen)
	{
		for (int i = 0; SDL_GetTicks() > nextGameTick && i < applicationData->maxFrameSkip; ++i)
		{
			[[self currentState] tick: gameTickLengthInSeconds];
			nextGameTick += gameTickLength;
		}

		// Handle events
		[self handleEvents];

		// Calculate interpolation
		applicationData->interpolation = (float)(SDL_GetTicks() + gameTickLength - nextGameTick)/(float)gameTickLength;

		// Redraw
		glClear(GL_COLOR_BUFFER_BIT);
		[[[self currentState] view] display];
		SDL_GL_SwapBuffers();

		// Empty autorelease pool
		[self refreshAutoreleasePool];
	}
}

- (void)closeScreen
{
	applicationData->isOpen = NO;
}

#pragma mark -

- (MOState *)currentState
{
	return [applicationData->stateStack lastObject];
}

- (void)pushState: (MOState *)aState
{
	[applicationData->stateStack addObject: aState];
}

- (MOState *)popCurrentState
{
	MOState *removedState = [self currentState];
	[applicationData->stateStack removeLastObject];
	return removedState;
}

- (MOState *)replaceCurrentStateWith: (MOState *)aState
{
	MOState *removedState = [self popCurrentState];
	[self pushState: aState];
	return removedState;
}

#pragma mark -

- (float)interpolation
{
	return applicationData->interpolation;
}

- (MOPoint)mouseLocation
{
	int x,y;
	SDL_GetMouseState(&x, &y);

	return MOPointMake(x, applicationData->screenSize.h-y-1);
}

@end
