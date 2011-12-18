#import <Monet/MOApplication.h>

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <SDL/SDL_mixer.h>

#import <Monet/MOEvent.h>
#import <Monet/MOView.h>
#import <Monet/Private.h>

struct _MOApplication
{
	COGuts            *guts;

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

void _MOApplicationDestroy(void *self);

void _MOApplicationRefreshAutoreleasePool(MOApplication *self)
{
	[self->autoreleasePool release];
	self->autoreleasePool = [[NSAutoreleasePool alloc] init];
}

void _MOApplicationHandleEvents(MOApplication *self)
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
					MOEvent *moEvent = MOEventCreateKey(
						MOKeyDownEventType,
						MOSDLModToMOKeyModifierMask(event.key.keysym.mod),
						[character UTF8String],
						MOSDLKeyToMOKey(event.key.keysym.sym));

					// Dispatch event
					[[MOApplicationGetCurrentState(self) view] keyDown: moEvent];

					// Cleanup
					[character release];
					CORelease(moEvent);
				}
				break;

			case SDL_KEYUP:
				{
					// Create event
					MOEvent *moEvent = MOEventCreateKey(
						MOKeyUpEventType,
						MOSDLModToMOKeyModifierMask(event.key.keysym.mod),
						NULL,
						MOSDLKeyToMOKey(event.key.keysym.sym));

					// Dispatch event
					[[MOApplicationGetCurrentState(self) view] keyUp: moEvent];

					// Cleanup
					CORelease(moEvent);
				}
				break;

			case SDL_MOUSEMOTION:
				{
					// Create event
					MOEvent *moEvent = MOEventCreateMouseMotion(
						MOSDLModToMOKeyModifierMask(SDL_GetModState()),
						MOPointMake(event.motion.x, self->screenSize.h-event.motion.y-1),
						MOPointMake(event.motion.xrel, event.motion.yrel)
					);

					// Dispatch event to subviews that want it
					if (self->lastLeftMouseButtonDownView)
						[self->lastLeftMouseButtonDownView mouseDragged: moEvent];
					if (self->lastMiddleMouseButtonDownView)
						[self->lastMiddleMouseButtonDownView mouseDragged: moEvent];
					if (self->lastRightMouseButtonDownView)
						[self->lastRightMouseButtonDownView mouseDragged: moEvent];

					// Cleanup
					CORelease(moEvent);
				}
				break;

			case SDL_MOUSEBUTTONDOWN:
				{
					// Get event information
					MOPoint mouseLocation		= MOPointMake(
						event.button.x,
						self->screenSize.h-event.button.y-1);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					uint8_t modifiers			= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find deepest subview
					MOView *subview = [[MOApplicationGetCurrentState(self) view] deepestSubviewAtPoint: mouseLocation];

					// Set last view receiving event
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							self->lastLeftMouseButtonDownView = subview;
							break;

						case MOMiddleMouseButton:
							self->lastMiddleMouseButtonDownView = subview;
							break;

						case MORightMouseButton:
							self->lastRightMouseButtonDownView = subview;
							break;
					}

					// Create event
					MOEvent *moEvent = MOEventCreateMouseButton(
						MOMouseButtonDownEventType,
						modifiers,
						mouseButton,
						mouseLocation,
						1); // FIXME set correct click count

					// Dispatch event
					[subview mouseDown: moEvent];

					// Cleanup
					CORelease(moEvent);
				}
				break;

			case SDL_MOUSEBUTTONUP:
				{
					// Get event information
					MOPoint mouseLocation		= MOPointMake(
						event.button.x,
						self->screenSize.h-event.button.y-1);
					MOMouseButton mouseButton	= MOSDLMouseButtonToMOMouseButton(event.button.button);
					uint8_t modifiers			= MOSDLModToMOKeyModifierMask(SDL_GetModState());

					// Find subview
					// FIXME won’t work well if game state is different
					MOView *subview = nil;
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							subview = self->lastLeftMouseButtonDownView;
							break;

						case MOMiddleMouseButton:
							subview = self->lastMiddleMouseButtonDownView;
							break;

						case MORightMouseButton:
							subview = self->lastRightMouseButtonDownView;
							break;
					}

					// Create event
					MOEvent *moEvent = MOEventCreateMouseButton(
						MOMouseButtonUpEventType,
						modifiers,
						mouseButton,
						mouseLocation,
						1); // FIXME set correct click count

					// Dispatch event
					[subview mouseUp: moEvent];

					// Clear relevant subview
					switch(mouseButton)
					{
						case MOLeftMouseButton:
							self->lastLeftMouseButtonDownView = nil;
							break;

						case MOMiddleMouseButton:
							self->lastMiddleMouseButtonDownView = nil;
							break;

						case MORightMouseButton:
							self->lastRightMouseButtonDownView = nil;
							break;
					}


					// Cleanup
					CORelease(moEvent);
				}
				break;

			case SDL_USEREVENT:
				{
					MOTimer *timer = event.user.data1;
					MOEvent *moEvent = MOEventCreateTimer(timer);
					[[MOApplicationGetCurrentState(self) view] timerFired: moEvent];
					CORelease(moEvent);
				}
				break;

			case SDL_QUIT:
				MOApplicationCloseScreen(self);
				break;
		}
	}
}

MOApplication *MOApplicationCreate(void)
{
	MOApplication *application = calloc(1, sizeof (MOApplication));
	COInitialize(application);
	COSetDestructor(application, &_MOApplicationDestroy);

	application->stateStack         = [[NSMutableArray alloc] init];
	application->gameTicksPerSecond = 30;
	application->maxFrameSkip       = 3;

	return application;
}

void _MOApplicationDestroy(void *self)
{
	MOApplication *application = (MOApplication *)self;

	[application->stateStack release];
	SDL_FreeSurface(application->surface);
	SDL_Quit();
}

MOSize MOApplicationGetScreenSize(MOApplication *self)
{
	return self->screenSize;
}

void MOApplicationSetScreenSize(MOApplication *self, MOSize aScreenSize)
{
	self->screenSize = aScreenSize;
}

bool MOApplicationIsFullscreen(MOApplication *self)
{
	return self->isFullscreen;
}

void MOApplicationSetIsFullscreen(MOApplication *self, bool aIsFullscreen)
{
	self->isFullscreen = aIsFullscreen;
}

uint8_t MOApplicationGetGameTicksPerSecond(MOApplication *self)
{
	return self->gameTicksPerSecond;
}

void MOApplicationSetGameTicksPerSecond(MOApplication *self, uint8_t aGameTicksPerSecond)
{
	self->gameTicksPerSecond = aGameTicksPerSecond;
}

uint8_t MOApplicationGetMaxFrameSkip(MOApplication *self)
{
	return self->maxFrameSkip;
}

void MOApplicationSetMaxFrameSkip(MOApplication *self, uint8_t aMaxFrameSkip)
{
	self->maxFrameSkip = aMaxFrameSkip;
}

MOState *MOApplicationGetCurrentState(MOApplication *self)
{
	return [self->stateStack lastObject];
}

void MOApplicationPushState(MOApplication *self, MOState *aState)
{
	[self->stateStack addObject: aState];
}

MOState *MOApplicationPopCurrentState(MOApplication *self)
{
	MOState *removedState = [[MOApplicationGetCurrentState(self) retain] autorelease];
	[self->stateStack removeLastObject];
	return removedState;
}

MOState *MOApplicationReplaceCurrentState(MOApplication *self, MOState *aState)
{
	MOState *removedState = MOApplicationPopCurrentState(self);
	MOApplicationPushState(self, aState);
	return removedState;
}

void MOApplicationOpenScreen(MOApplication *self)
{
	// Setup autorelease pool
	_MOApplicationRefreshAutoreleasePool(self);

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
		[NSException raise: @"SDLException" format: @"Mix_OpenAudio failed\n"];
	Mix_AllocateChannels(32);

	// Create screen
	Uint32 flags = SDL_OPENGL | (self->isFullscreen ? SDL_FULLSCREEN : 0);
	self->surface = SDL_SetVideoMode(self->screenSize.w, self->screenSize.h, 0, flags);
	if (!self->surface)
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
	gluOrtho2D(0, self->surface->w, 0, self->surface->h);

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
	self->isOpen = YES;
}

void MOApplicationEnterRunloop(MOApplication *self)
{
	Uint32 gameTickLength          = 1000/self->gameTicksPerSecond;
	double gameTickLengthInSeconds = 1.0/(double)self->gameTicksPerSecond;
	Uint32 nextGameTick            = SDL_GetTicks();

	while (self->isOpen)
	{
		for (int i = 0; SDL_GetTicks() > nextGameTick && i < self->maxFrameSkip; ++i)
		{
			[MOApplicationGetCurrentState(self) tick: gameTickLengthInSeconds];
			nextGameTick += gameTickLength;
		}

		// Handle events
		_MOApplicationHandleEvents(self);

		// Calculate interpolation
		self->interpolation = (float)(SDL_GetTicks() + gameTickLength - nextGameTick)/(float)gameTickLength;

		// Redraw
		glClear(GL_COLOR_BUFFER_BIT);
		[[MOApplicationGetCurrentState(self) view] display];
		SDL_GL_SwapBuffers();

		// Empty autorelease pool
		_MOApplicationRefreshAutoreleasePool(self);
	}
}

void MOApplicationCloseScreen(MOApplication *self)
{
	self->isOpen = NO;
}

float MOApplicationGetInterpolation(MOApplication *self)
{
	return self->interpolation;
}

MOPoint MOApplicationGetMouseLocation(MOApplication *self)
{
	int x,y;
	SDL_GetMouseState(&x, &y);

	return MOPointMake(x, self->screenSize.h-y-1);
}
