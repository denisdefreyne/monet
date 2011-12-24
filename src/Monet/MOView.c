#include <Monet/MOView.h>

#include <Monet/Common.h>

#include <Monet/MOEvent.h>
#include <Monet/MOApplication.h>
#include <Monet/MOGraphicsContext.h>
#include <Monet/Private.h>

struct _MOView
{
	COGuts                            guts;

	MOApplication                     *application;

	MOView                            *superview;
	SBArray                           *subviews;

	MORect                            frame;
	MORect                            bounds;

	MOGraphicsContext                 *graphicsContext;

	MOViewDrawRectCallback            drawRectCallback;
	MOViewTickCallback                tickCallback;

	MOViewKeyPressedCallback          keyPressedCallback;
	MOViewKeyReleasedCallback         keyReleasedCallback;
	MOViewMouseButtonPressedCallback  mouseButtonPressedCallback;
	MOViewMouseButtonReleasedCallback mouseButtonReleasedCallback;
	MOViewMouseDraggedCallback        mouseDraggedCallback;
	MOViewTimerFiredCallback          timerFiredCallback;

	void                              *extra;
};

void _MOViewDestroy(void *self);

COClass MOViewClass = {
	.superclass = NULL,
	.destructor = &_MOViewDestroy
};

MOView *MOViewCreate(MORect aFrame, MOApplication *aApplication)
{
	MOView *view = calloc(1, sizeof (MOView));
	COInitialize(view, &MOViewClass);

	view->frame       = aFrame;
	view->application = aApplication;

	view->bounds.w    = view->frame.w;
	view->bounds.h    = view->frame.h;

	view->subviews    = SBArrayCreateWithCapacity(3);

	return view;
}

void _MOViewDestroy(void *self)
{
	MOView *view = self;

	CORelease(view->subviews);
	CORelease(view->graphicsContext);
}

void MOViewSetDrawRectCallback(MOView *self, MOViewDrawRectCallback aCallback)
{
	self->drawRectCallback = aCallback;
}

void MOViewSetTickCallback(MOView *self, MOViewTickCallback aCallback)
{
	self->tickCallback = aCallback;
}

void MOViewSetKeyPressedCallback(MOView *self, MOViewKeyPressedCallback aCallback)
{
	self->keyPressedCallback = aCallback;
}

void MOViewSetKeyReleasedCallback(MOView *self, MOViewKeyReleasedCallback aCallback)
{
	self->keyReleasedCallback = aCallback;
}

void MOViewSetMouseButtonPressedCallback(MOView *self, MOViewMouseButtonPressedCallback aCallback)
{
	self->mouseButtonPressedCallback = aCallback;
}

void MOViewSetMouseButtonReleasedCallback(MOView *self, MOViewMouseButtonReleasedCallback aCallback)
{
	self->mouseButtonReleasedCallback = aCallback;
}

void MOViewSetMouseDraggedCallback(MOView *self, MOViewMouseDraggedCallback aCallback)
{
	self->mouseDraggedCallback = aCallback;
}

void MOViewSetTimerFiredCallback(MOView *self, MOViewTimerFiredCallback aCallback)
{
	self->timerFiredCallback = aCallback;
}

MOApplication *MOViewGetApplication(MOView *self)
{
	return self->application;
}

void *MOViewGetExtra(MOView *self)
{
	return self->extra;
}

void MOViewSetExtra(MOView *self, void *aExtra)
{
	// FIXME retain or not?
	self->extra = aExtra;
}

MOView *MOViewGetSuperview(MOView *self)
{
	return self->superview;
}

void MOViewSetSuperview(MOView *self, MOView *aSuperview)
{
	self->superview = aSuperview;
}

SBArray *MOViewGetSubviews(MOView *self)
{
	return self->subviews;
}

void MOViewAddSubview(MOView *self, MOView *aSubview)
{
	SBArrayPush(self->subviews, aSubview);
	MOViewSetSuperview(aSubview, self);
}

MOPoint MOViewGetAbsoluteOrigin(MOView *self)
{
	MOPoint basicOrigin = MOPointMake(self->frame.x, self->frame.y);

	if (!self->superview)
		return basicOrigin;
	else
		return MOViewConvertPointToScreen(self->superview, basicOrigin);
}

MOPoint MOViewConvertPointFromScreen(MOView *self, MOPoint aPoint)
{
	MOPoint absoluteOrigin = MOViewGetAbsoluteOrigin(self);
	return MOPointMake(aPoint.x - absoluteOrigin.x, aPoint.y - absoluteOrigin.y);
}

MOPoint MOViewConvertPointToScreen(MOView *self, MOPoint aPoint)
{
	MOPoint absoluteOrigin = MOViewGetAbsoluteOrigin(self);
	return MOPointMake(aPoint.x + absoluteOrigin.x, aPoint.y + absoluteOrigin.y);
}

// aPoint is relative to the screen here, not the view.
MOView *MOViewGetSubviewAtPoint(MOView *self, MOPoint aPoint)
{
	SBArrayIndex size = SBArrayGetSize(self->subviews);
	for (SBArrayIndex i = 0; i < size; ++i)
	{
		MOView *subview = SBArrayAt(self->subviews, i);
		MOPoint convertedPoint = MOViewConvertPointFromScreen(subview, aPoint);
		if (MORectContainsPoint(MOViewGetBounds(subview), convertedPoint))
			return subview;
	}

	return NULL;
}

// aPoint is relative to the screen here, not the view.
MOView *MOViewGetDeepestSubviewAtPoint(MOView *self, MOPoint aPoint)
{
	MOView *subview = self;
	while (1)
	{
		MOView *newSubview = MOViewGetSubviewAtPoint(subview, aPoint);
		if (newSubview)
			subview = newSubview;
		else
			break;
	}

	return subview;
}

MORect MOViewGetFrame(MOView *self)
{
	return self->frame;
}

MORect MOViewGetBounds(MOView *self)
{
	return self->bounds;
}

MORect MOViewGetBoundsRelativeToWindow(MOView *self)
{
	MOPoint absoluteOrigin = MOViewGetAbsoluteOrigin(self);
	return MORectMake(absoluteOrigin.x, absoluteOrigin.y, self->bounds.w, self->bounds.h);
}

void MOViewLockFocus(MOView *self)
{
	if (!self->graphicsContext)
	{
		// Get destination rectangle
		MOPoint absoluteOrigin = MOViewGetAbsoluteOrigin(self);
		MORect rect = MORectMake(absoluteOrigin.x, absoluteOrigin.y, self->frame.w, self->frame.h);

		// Create graphics context
		self->graphicsContext = MOGraphicsContextCreate(rect);
	}

	MOGraphicsContext_push(self->graphicsContext);
}

void MOViewUnlockFocus(MOView *self)
{
	MOGraphicsContext_pop();
}

void MOViewDisplay(MOView *self)
{
	// Set up clipping
	MOPoint absoluteOrigin = MOViewGetAbsoluteOrigin(self);
	glScissor(absoluteOrigin.x, absoluteOrigin.y, self->bounds.w, self->bounds.h);

	// Draw this view
	MOViewLockFocus(self);
	MOViewDrawRect(self, MOViewGetBounds(self));
	MOViewUnlockFocus(self);

	// Draw subviews
	SBArrayIndex size = SBArrayGetSize(self->subviews);
	for (SBArrayIndex i = 0; i < size; ++i)
	{
		MOView *subview = SBArrayAt(self->subviews, i);
		MOViewDisplay(subview);
	}
}

void MOViewClear(MOView *self)
{
	glClear(GL_COLOR_BUFFER_BIT);
}

void MOViewDrawRect(MOView *self, MORect aRect)
{
	if (self->drawRectCallback)
		self->drawRectCallback(self, aRect);
}

void MOViewTick(MOView *self, double aSeconds)
{
	if (self->tickCallback)
		self->tickCallback(self, aSeconds);
}

bool MOViewKeyPressed(MOView *self, MOEvent *aEvent)
{
	bool wasHandled;

	// Try handling here
	if (self->keyPressedCallback)
	{
		wasHandled = self->keyPressedCallback(self, aEvent);
		if (wasHandled)
			return true;
	}

	// Pass on to subviews
	SBArrayIndex size = SBArrayGetSize(self->subviews);
	for (SBArrayIndex i = 0; i < size; ++i)
	{
		MOView *subview = SBArrayAt(self->subviews, i);
		wasHandled = MOViewKeyPressed(subview, aEvent);
		if (wasHandled)
			return true;
	}

	return false;
}

bool MOViewKeyReleased(MOView *self, MOEvent *aEvent)
{
	bool wasHandled;

	// Try handling here
	if (self->keyReleasedCallback)
	{
		wasHandled = self->keyReleasedCallback(self, aEvent);
		if (wasHandled)
			return true;
	}

	// Pass on to subviews
	SBArrayIndex size = SBArrayGetSize(self->subviews);
	for (SBArrayIndex i = 0; i < size; ++i)
	{
		MOView *subview = SBArrayAt(self->subviews, i);
		wasHandled = MOViewKeyReleased(subview, aEvent);
		if (wasHandled)
			return true;
	}

	return false;
}

void MOViewMouseButtonPressed(MOView *self, MOEvent *aEvent)
{
	// arrives in the lowest view

	// Try to handle here
	MOViewMouseButtonPressedCallback callback = self->mouseButtonPressedCallback;
	bool wasHandled = callback ? callback(self, aEvent) : false;

	// Pass on to superview
	if (!wasHandled && self->superview)
		MOViewMouseButtonPressed(self->superview, aEvent);
}

void MOViewMouseButtonReleased(MOView *self, MOEvent *aEvent)
{
	// arrives in the lowest view

	// Try to handle here
	MOViewMouseButtonReleasedCallback callback = self->mouseButtonReleasedCallback;
	bool wasHandled = callback ? callback(self, aEvent) : false;

	// Pass on to superview
	if (!wasHandled && self->superview)
		MOViewMouseButtonReleased(self->superview, aEvent);
}

void MOViewMouseDragged(MOView *self, MOEvent *aEvent)
{
	// arrives in the lowest view

	// Try to handle here
	MOViewMouseDraggedCallback callback = self->mouseDraggedCallback;
	bool wasHandled = callback ? callback(self, aEvent) : false;

	// Pass on to superview
	if (!wasHandled && self->superview)
		MOViewMouseDragged(self->superview, aEvent);
}

void MOViewTimerFired(MOView *self, MOEvent *aEvent)
{
	// arrives in the highest (topmost) view

	if (self->timerFiredCallback)
		self->timerFiredCallback(self, aEvent);
}
