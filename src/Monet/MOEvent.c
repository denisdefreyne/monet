#include <Monet/MOEvent.h>

#include <string.h>

#include <Monet/Common.h>

struct _MOEvent
{
	COGuts          *guts;

	MOEventType     type;
	uint8_t         modifiers;

	char            *character;
	MOKey           key;

	MOMouseButton   mouseButton;
	MOPoint         mouseLocation;
	MOPoint         relativeMouseMotion;
	uint8_t         clickCount;

	MOTimer         *timer;
};

void _MOEventDestroy(void *aEvent);

MOEvent *MOEventCreateKey(MOEventType aType, MOKeyModifierMask aModifiers, char *aCharacter, MOKey aKey)
{
	MOEvent *event = calloc(1, sizeof (MOEvent));
	COInitialize(event);
	COSetDestructor(event, &_MOEventDestroy);

	event->type      = aType;
	event->modifiers = aModifiers;

	event->character = aCharacter ? strdup(aCharacter) : NULL;
	event->key       = aKey;

	return event;
}

MOEvent *MOEventCreateMouseButton(MOEventType aType, MOKeyModifierMask aModifiers, MOMouseButton aMouseButton, MOPoint aMouseLocation, uint8_t aClickCount)
{
	MOEvent *event = calloc(1, sizeof (MOEvent));
	COInitialize(event);
	COSetDestructor(event, &_MOEventDestroy);

	event->type          = aType;
	event->modifiers     = aModifiers;

	event->mouseButton   = aMouseButton;
	event->mouseLocation = aMouseLocation;
	event->clickCount    = aClickCount;

	return event;
}

MOEvent *MOEventCreateMouseMotion(MOKeyModifierMask aModifiers, MOPoint aMouseLocation, MOPoint aRelativeMouseMotion)
{
	MOEvent *event = calloc(1, sizeof (MOEvent));
	COInitialize(event);
	COSetDestructor(event, &_MOEventDestroy);

	event->type                = MOMouseMotionEventType;
	event->modifiers           = aModifiers;
        
	event->mouseLocation       = aMouseLocation;
	event->relativeMouseMotion = aRelativeMouseMotion;

	return event;
}

MOEvent *MOEventCreateTimer(MOTimer *aTimer)
{
	MOEvent *event = calloc(1, sizeof (MOEvent));
	COInitialize(event);
	COSetDestructor(event, &_MOEventDestroy);

	event->type  = MOTimerFiredEventType;

	event->timer = CORetain(aTimer);

	return event;
}

void _MOEventDestroy(void *aEvent)
{
	MOEvent *event = (MOEvent *)aEvent;

	if (event->character)
		free(event->character);
	CORelease(event->timer);
}

MOEventType MOEventGetType(MOEvent *aEvent)
{
	return aEvent->type;
}

MOKeyModifierMask MOEventGetModifiers(MOEvent *aEvent)
{
	return aEvent->modifiers;
}

char *MOEventGetCharacter(MOEvent *aEvent)
{
	return aEvent->character;
}

MOKey MOEventGetKey(MOEvent *aEvent)
{
	return aEvent->key;
}

MOMouseButton MOEventGetMouseButton(MOEvent *aEvent)
{
	return aEvent->mouseButton;
}

MOPoint MOEventGetMouseLocation(MOEvent *aEvent)
{
	return aEvent->mouseLocation;
}

MOPoint MOEventGetRelativeMouseMotion(MOEvent *aEvent)
{
	return aEvent->relativeMouseMotion;
}

uint8_t MOEventGetClickCount(MOEvent *aEvent)
{
	return aEvent->clickCount;
}

MOTimer *MOEventGetTimer(MOEvent *aEvent)
{
	return aEvent->timer;
}
