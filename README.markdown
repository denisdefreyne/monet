Monet
=====

...

Requirements
------------

* SDL
* SDL_image
* OpenGL
* Foundation

Foundation is part of Cocoa, which comes with Mac OS X. There are several open-source implementations for Foundation:

* [Cocotron](http://www.cocotron.org/) (probably the most complete)
* [libFoundation](http://www.geocities.com/SiliconValley/Monitor/7464/libFoundation/) (likely outdated)
* [nuFound](http://github.com/timburks/nufound/tree/master) (possibly incomplete)
* [GNUstep](http://www.gnustep.org/)

Goals
-----

Monet's goal is to be an Objective-C wrapper for SDL, inspired by Cocoa's AppKit.

Ideally, an application that uses Monet should be able to do everything it needs without needing to interface with SDL directly. However, not all functionality from SDL will be available in Monet; features that are not used in Llama will be left out.

History
------

First, there was Gosu-Monet (Gosu + Ruby). Then, there was Allegro-Monet (Allegro + Obj-C). Now, there is SDL-Monet (SDL + Obj-C).

Usage
-----

...

### Starting

1. Create a `MOApplication`
2. Configure the application (`setScreenSize:`, `setFullscreen:`, ...)
3. Set the model, if any (`setModel:`)
4. Open the screen (`open`)
5. Create the content view (`setMainView:`)
6. Enter runloop (`enterRunloop`)

### Drawing

The `-[MOView drawRect:]` method should be implemented in subclasses. This method should draw the view. The rect argument specifies the rectangle that should be drawn (at the moment of writing, the rectangle isn't set, so the entire view must always be redrawn).

Before this method is called, the focus will be auto-locked on the view. When drawing elsewhere (e.g. into an image), the focus must be locked on the object that is being drawn to first.

It is not necessary to explicitly draw the subviews; this will be done automatically. It is also not necessary to call `super` in the `-drawRect:` method.

### Event handling

#### Mouse events

Mouse events are sent immediately to the deepest subview.

When a view has successfully handled an event, the event should be discarded. When a view can't handle the specific event, the method handling the event should forward the event to the superview (which is what the default implementation does).

#### Key events

Key events are sent to the screen's content view, unless there is a first responder, in which case the even will be sent immediately to the first responder.

When a view successfully handles an event, the event is discarded. When a view receiving a key event does not know how to handle it, it will sequentially forward the event to all of its subviews, until either it wasn't handled by any subviews, or it was handled by one subview, in which case the event will not be forwarded to the remaining subviews but will be discarded instead.

Relationships with Other Frameworks
-----------------------------------

...

### SDL

Monet could be considered an Obj-C wrapper for SDL, but it's more than that. Monet provides additional functionality which makes it easier to use than SDL. For example, Monet offers views that define drawing and event handling regions.

### Cocoa

Monet, being an Obj-C framework, is inspired by Cocoa, but the interfaces don't always match. For example, event handling is much simpler than in Cocoa (because a system as complex as Cocoa's is simply not necessary).
