#ifndef __MONET_MOSTATE_H__
#define __MONET_MOSTATE_H__

#include <Monet/Common.h>

typedef struct _MOState MOState;

#include <Monet/MOApplication.h>
#include <Monet/MOView.h>

typedef MOView * (*MOStateViewConstructor)(MOApplication *aApplication);
typedef void (*MOStateWorldTicker)(MOState *aState, double aGameTickLengthInSeconds);

MOState *MOStateCreate(MOApplication *aApplication, MOStateViewConstructor aCallback);

MOView *MOStateGetView(MOState *aState);
void *MOStateGetWorld(MOState *aState);
void MOStateSetWorld(MOState *aState, void *aWorld);
void MOStateSetWorldTickerFunction(MOState *aState, MOStateWorldTicker);

void MOStateTick(MOState *aState, double aGameTickLengthInSeconds);

#endif
