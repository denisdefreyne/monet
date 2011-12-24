#ifndef __MONET_MOBUTTON_H__
#define __MONET_MOBUTTON_H__

#include <Monet/Common.h>

extern COClass MOButtonClass;

#include <Monet/MOApplication.h>
#include <Monet/MORect.h>
#include <Monet/MOView.h>

typedef void (*MOButtonClickedCallback)(MOView *self);

MOView *MOButtonCreate(MORect aFrame, MOApplication *aApplication);

void MOButtonSetClickedCallback(MOView *self, MOButtonClickedCallback aCallback);

#endif
