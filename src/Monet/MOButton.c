#include <Monet/MOButton.h>

#include <cobject/cobject.h>
#include <stdlib.h>

#include <Monet/MOApplication.h>
#include <Monet/MOPoint.h>
#include <Monet/MORect.h>
#include <Monet/MOView.h>

struct _MOButtonExtra
{
	COGuts *guts;

	bool   isMouseDown;
	bool   isMouseInside;

	MOButtonClickedCallback clickedCallback;
};
typedef struct _MOButtonExtra MOButtonExtra;

bool _MOButtonIsMousePressed(MOView *self)
{
	MOButtonExtra *extra = MOViewGetExtra(self);

	MORect bounds = MOViewGetBounds(self);
	MOPoint untranslatedPoint = MOApplicationGetMouseLocation(MOViewGetApplication(self));
	MOPoint point = MOViewConvertPointFromScreen(self, untranslatedPoint);
	return extra->isMouseDown && MORectContainsPoint(bounds, point);
}

bool _MOButtonMouseButtonPressed(MOView *self, MOEvent *aEvent)
{
	MOButtonExtra *extra = MOViewGetExtra(self);

	extra->isMouseDown = true;

	return true;
}

bool _MOButtonMouseButtonReleased(MOView *self, MOEvent *aEvent)
{
	MOButtonExtra *extra = MOViewGetExtra(self);

	if (_MOButtonIsMousePressed(self))
		extra->clickedCallback(self);

	extra->isMouseDown = false;

	return true;
}

MOView *MOButtonCreate(MORect aFrame, MOApplication *aApplication)
{
	MOView *view = MOViewCreate(aFrame, aApplication);

	MOButtonExtra *extra = calloc(1, sizeof (MOButtonExtra));
	COInitialize(extra);
	MOViewSetExtra(view, extra);

	MOViewSetMouseButtonPressedCallback(view, &_MOButtonMouseButtonPressed);
	MOViewSetMouseButtonReleasedCallback(view, &_MOButtonMouseButtonReleased);

	return view;
}

void MOButtonSetClickedCallback(MOView *self, MOButtonClickedCallback aCallback)
{
	MOButtonExtra *extra = MOViewGetExtra(self);
	extra->clickedCallback = aCallback;
}
