#ifndef __MONET_MOVIEW_H__
#define __MONET_MOVIEW_H__

#include <Monet/Common.h>

typedef struct _MOView MOView;

#include <Monet/MOApplication.h>
#include <Monet/MOEvent.h>
#include <Monet/MORect.h>

typedef void (*MOViewDrawRectCallback)(MOView *self, MORect aRect);
typedef void (*MOViewTickCallback)(MOView *self, double aSeconds);

typedef bool (*MOViewKeyPressedCallback)(MOView *self, MOEvent *aEvent);
typedef bool (*MOViewKeyReleasedCallback)(MOView *self, MOEvent *aEvent);
typedef bool (*MOViewMouseButtonPressedCallback)(MOView *self, MOEvent *aEvent);
typedef bool (*MOViewMouseButtonReleasedCallback)(MOView *self, MOEvent *aEvent);
typedef bool (*MOViewMouseDraggedCallback)(MOView *self, MOEvent *aEvent);
typedef bool (*MOViewTimerFiredCallback)(MOView *self, MOEvent *aEvent);

MOView *MOViewCreate(MORect aFrame, MOApplication *aApplication);

void MOViewSetDrawRectCallback(MOView *self, MOViewDrawRectCallback aCallback);
void MOViewSetTickCallback(MOView *self, MOViewTickCallback aCallback);

void MOViewSetKeyPressedCallback(MOView *self, MOViewKeyPressedCallback aCallback);
void MOViewSetKeyReleasedCallback(MOView *self, MOViewKeyReleasedCallback aCallback);
void MOViewSetMouseButtonPressedCallback(MOView *self, MOViewMouseButtonPressedCallback aCallback);
void MOViewSetMouseButtonReleasedCallback(MOView *self, MOViewMouseButtonReleasedCallback aCallback);
void MOViewSetMouseDraggedCallback(MOView *self, MOViewMouseDraggedCallback aCallback);
void MOViewSetTimerFiredCallback(MOView *self, MOViewTimerFiredCallback aCallback);

MOApplication *MOViewGetApplication(MOView *self);
void *MOViewGetExtra(MOView *self);
void MOViewSetExtra(MOView *self, void *aExtra);

MOView *MOViewGetSuperview(MOView *self);
void MOViewSetSuperview(MOView *self, MOView *aSuperview);
SBArray *MOViewGetSubviews(MOView *self);
void MOViewAddSubview(MOView *self, MOView *aSubview);

MOPoint MOViewGetAbsoluteOrigin(MOView *self);
MOPoint MOViewConvertPointFromScreen(MOView *self, MOPoint aPoint);
MOPoint MOViewConvertPointToScreen(MOView *self, MOPoint aPoint);

MOView *MOViewGetSubviewAtPoint(MOView *self, MOPoint aPoint);
MOView *MOViewGetDeepestSubviewAtPoint(MOView *self, MOPoint aPoint);

MORect MOViewGetFrame(MOView *self);
MORect MOViewGetBounds(MOView *self);
MORect MOViewGetBoundsRelativeToWindow(MOView *self);

void MOViewLockFocus(MOView *self);
void MOViewUnlockFocus(MOView *self);

void MOViewDisplay(MOView *self);
void MOViewClear(MOView *self);

void MOViewDrawRect(MOView *self, MORect aRect);
void MOViewTick(MOView *self, double aSeconds);

bool MOViewKeyPressed(MOView *self, MOEvent *aEvent);
bool MOViewKeyReleased(MOView *self, MOEvent *aEvent);
void MOViewMouseButtonPressed(MOView *self, MOEvent *aEvent);
void MOViewMouseButtonReleased(MOView *self, MOEvent *aEvent);
void MOViewMouseDragged(MOView *self, MOEvent *aEvent);
void MOViewTimerFired(MOView *self, MOEvent *aEvent);

#endif
