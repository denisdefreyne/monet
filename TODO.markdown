To Do
=====

Miscellaneous
------------

* Prevent tearing
* Cursors

Events
------

### Mouse events

Definitely:

* mouseDown
* mouseUp

Maybe later:

* mouseMoved
* mouseDragged
* mouseEntered
* mouseExited

Will also need events for the right mouse button, middle mouse button, ... maybe store the mouse button type in the event?

Mouse events are sent immediately to the deepest subview.

When a view has successfully handled an event, the event should be discarded. When a view can't handle the specific event, the method handling the event should forward the event to the superview (which is what the default implementation does).

### Key events

* keyDown
* keyUp

Key events are sent to the screen's content view, unless there is a first responder, in which case the even will be sent immediately to the first responder.

When a view successfully handles an event, the event is discarded. When a view receiving a key event does not know how to handle it, it will sequentially forward the event to all of its subviews, until either it wasn't handled by any subviews, or it was handled by one subview, in which case the event will not be forwarded to the remaining subviews but will be discarded instead.
