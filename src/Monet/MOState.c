#include <Monet/MOState.h>

#include <Monet/Common.h>

#include <Monet/MORect.h>

struct _MOState
{
	COGuts guts;

	MOApplication      *application;
	MOView             *view;
	void               *world;
	MOStateWorldTicker worldTicker;
};

void _MOStateDestroy(void *aState);

COClass MOStateClass = {
	.superclass = NULL,
	.destructor = &_MOStateDestroy
};

MOState *MOStateCreate(MOApplication *aApplication, MOStateViewConstructor aCallback)
{
	MOState *state = calloc(1, sizeof (MOState));
	COInitialize(state, &MOStateClass);

	state->application = aApplication;
	state->view = aCallback(aApplication);

	return state;
}

void _MOStateDestroy(void *aState)
{
	MOState *state = aState;

	CORelease(state->view);
	CORelease(state->world);
}

MOView *MOStateGetView(MOState *aState)
{
	return aState->view;
}

void *MOStateGetWorld(MOState *aState)
{
	return aState->world;
}

void MOStateSetWorld(MOState *aState, void *aWorld)
{
	CO_SET_RR(aState->world, aWorld);
}

void MOStateSetWorldTickerFunction(MOState *aState, MOStateWorldTicker aCallback)
{
	aState->worldTicker = aCallback;
}

void MOStateTick(MOState *aState, double aGameTickLengthInSeconds)
{
	MOViewTick(aState->view, aGameTickLengthInSeconds);
	if (aState->worldTicker)
		aState->worldTicker(aState, aGameTickLengthInSeconds);
}
