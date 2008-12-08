#import <Monet/MOApplication.h>

#import <Foundation/Foundation.h>

#import <Monet/MOEvent.h>
#import <Monet/MOSpeedCounter.h>
#import <Monet/MOView.h>
#import <Monet/Private.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

@interface MOApplication (Autoreleasing)

- (void)refreshAutoreleasePool;

@end

@implementation MOApplication (Autoreleasing)

- (void)refreshAutoreleasePool
{
	[autoreleasePool release];
	autoreleasePool = [[NSAutoreleasePool alloc] init];
}

@end

@interface MOApplication (Runloop)

- (void)handleEvents;

@end

@implementation MOApplication (Runloop)

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
					[self closeScreen];
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
					[mainView keyDown:moEvent];

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
					[mainView keyUp:moEvent];

					// Cleanup
					[moEvent release];
				}
				break;

			case SDL_MOUSEMOTION:
				{
					// Create event
					MOEvent *moEvent = [[MOEvent alloc] initMouseMotionEventWithModifiers:MOSDLModToMOKeyModifierMask(SDL_GetModState())
														mouseLocation:MOMakePoint(event.motion.x, screenSize.h-event.motion.y-1)
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
					MOPoint mouseLocation		= MOMakePoint(event.button.x, screenSize.h-event.button.y-1);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					UInt8 modifiers				= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find deepest subview
					MOView *subview = [mainView deepestSubviewAtPoint:mouseLocation];

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
					MOPoint mouseLocation		= MOMakePoint(event.button.x, screenSize.h-event.button.y-1);
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
				[self closeScreen];
				break;
		}
	}
}

@end

@implementation MOApplication

- (id)init
{
	if(self = [super init])
	{
		gameTicksPerSecond = 30;
	}

	return self;
}

- (void)dealloc
{
	SDL_FreeSurface(surface);
	SDL_Quit();

	[self setMainView:nil];
	[fpsCounter release];

	[super dealloc];
}

#pragma mark -

- (NSObject *)model
{
	return model;
}

- (void)setModel:(NSObject *)aModel
{
	[aModel retain];
	[model release];
	model = aModel;
}

- (MOView *)mainView
{
	return mainView;
}

- (void)setMainView:(MOView *)aMainView
{
	[aMainView retain];
	[mainView release];
	mainView = aMainView;
}

- (MOSize)screenSize
{
	return screenSize;
}

- (void)setScreenSize:(MOSize)aScreenSize
{
	screenSize = aScreenSize;
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

- (float)interpolation
{
	return interpolation;
}

- (void)setInterpolation:(float)aInterpolation
{
	interpolation = aInterpolation;
}

#pragma mark -

- (void)openScreen
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
	surface = SDL_SetVideoMode(screenSize.w, screenSize.h, 0, flags);
	if(!surface)
		[NSException raise:@"SDLException" format:@"SDL_SetVideoMode failed: %s\n", SDL_GetError()];

	// Set up texturing
	if(!gluCheckExtension("GL_EXT_texture_rectangle", glGetString(GL_EXTENSIONS)))
		[NSException raise:@"OpenGLException" format:@"Unsupported extension: GL_EXT_texture_rectangle"];
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

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
	gluOrtho2D(0, surface->w, 0, surface->h);

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

	Uint32	gameTickLength	= 1000/gameTicksPerSecond;
	Uint32	nextGameTick	= SDL_GetTicks();

	while(isOpen)
	{
		for(int i = 0; SDL_GetTicks() > nextGameTick && i < MAX_FRAMESKIP; ++i)
		{
			// Update game
			// TODO make this [model tick] and [controller tick]
			if([model respondsToSelector:@selector(tick)])
				[model performSelector:@selector(tick)];
			[mainView tick];

			// Record speed
			[gameSpeedCounter tick];

			nextGameTick += gameTickLength;
		}

		// Handle events
		[self handleEvents];

		// Calculate interpolation
		[self setInterpolation:(float)(SDL_GetTicks() + gameTickLength - nextGameTick)/(float)gameTickLength];

		// Redraw
		glClear(GL_COLOR_BUFFER_BIT);
		[mainView display];
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

- (void)closeScreen
{
	isOpen = NO;
}

#pragma mark -

- (MOPoint)mouseLocation
{
	int x,y;
	SDL_GetMouseState(&x, &y);

	return MOMakePoint(x, screenSize.h-y-1);
}

#pragma mark -

- (void)screenDidLoad
{
	// Do nothing by default
}

@end
