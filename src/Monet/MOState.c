#include <Monet/MOState.h>

#include <cobject/cobject.h>
#include <stdlib.h>

#include <Monet/MORect.h>

struct _MOState
{
	COGuts *guts;

	MOApplication      *application;
	MOView             *view;
	void               *world;
	MOStateWorldTicker worldTicker;
};

void _MOStateDestroy(void *aState);

MOState *MOStateCreate(MOApplication *aApplication, MOStateViewConstructor aCallback)
{
	MOState *state = calloc(1, sizeof (MOState));
	COInitialize(state);
	COSetDestructor(state, &_MOStateDestroy);

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
