#ifndef __MONET_MOBUTTON_H__
#define __MONET_MOBUTTON_H__

#include <Monet/Common.h>

extern COClass MOButtonClass;

typedef struct _MOButton MOButton;

#include <Monet/MOApplication.h>
#include <Monet/MORect.h>

typedef void (*MOButtonClickedCallback)(MOButton *self);

struct _MOButton
{
	MOView view;

	bool isMouseDown;
	bool isMouseInside;

	MOButtonClickedCallback clickedCallback;
};

void MOButtonInit(MOButton *aButton, MORect aFrame, MOApplication *aApplication);

MOView *MOButtonAsView(MOButton *aButton);

void MOButtonSetClickedCallback(MOButton *self, MOButtonClickedCallback aCallback);

#endif
