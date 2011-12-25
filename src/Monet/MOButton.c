#include <Monet/MOButton.h>

#include <Monet/Common.h>

#include <Monet/MOApplication.h>
#include <Monet/MOPoint.h>
#include <Monet/MORect.h>
#include <Monet/MOView.h>

COClass MOButtonClass = {
	.superclass = &MOViewClass,
	.destructor = NULL
};

bool _MOButtonIsMousePressed(MOButton *aButton)
{
	MOView *view = (MOView *)aButton;

	MORect bounds = MOViewGetBounds(view);
	MOPoint untranslatedPoint = MOApplicationGetMouseLocation(MOViewGetApplication(view));
	MOPoint point = MOViewConvertPointFromScreen(view, untranslatedPoint);

	return aButton->isMouseDown && MORectContainsPoint(bounds, point);
}

bool _MOButtonMouseButtonPressed(MOView *aView, MOEvent *aEvent)
{
	MOButton *button = (MOButton *)aView;

	button->isMouseDown = true;

	return true;
}

bool _MOButtonMouseButtonReleased(MOView *aView, MOEvent *aEvent)
{
	MOButton *button = (MOButton *)aView;

	if (_MOButtonIsMousePressed(button))
		button->clickedCallback(button);

	button->isMouseDown = false;

	return true;
}

void MOButtonInit(MOButton *aButton, MORect aFrame, MOApplication *aApplication)
{
	MOView *view = MOButtonAsView(aButton);

	MOViewInit(view, aFrame, aApplication);

	MOViewSetMouseButtonPressedCallback(view, &_MOButtonMouseButtonPressed);
	MOViewSetMouseButtonReleasedCallback(view, &_MOButtonMouseButtonReleased);
}

MOView *MOButtonAsView(MOButton *aButton)
{
	return (MOView *)aButton;
}

void MOButtonSetClickedCallback(MOButton *aButton, MOButtonClickedCallback aCallback)
{
	aButton->clickedCallback = aCallback;
}
