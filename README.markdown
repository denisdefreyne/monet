Monet
=====

Monet is a MVC library for writing hardware-accelerated 2D games.

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

Usage
-----

...

### Overview

`MOApplication` is the main class. It is responsible for creating a window (when using windowed mode) or managing the entire screen (when in fullscreen mode). It also contains the main game loop.

Each application has a single world, which is a object that responds to a `tick` method. This method indicates that the game state should move a step forward.

Drawing is handled by `MOView`, which is meant to be subclassed for every kind of view. `MOView` also takes care of event handling. Views should base what they're drawing on the state of the world.

### Starting the game

1. Create a `MOApplication`
2. Configure the application (`setScreenSize:`, `setFullscreen:`, ...)
3. Set the world, if any (`setWorld:`)
4. Open the screen (`openScreen`)
5. Create the content view (`setMainView:`)
6. Enter runloop (`enterRunloop`)

### Drawing & views

Drawing is handled by views. Each view is a `MOView` subclass that overrides `-drawRect:` to perform the actual drawing.(The `rect` argument is currently unused.)

Inside this method, all drawing operations will be performed inside the view. This is called the _focus_: before `-drawRect` is called, the view automatically received focus. It is possible to give other views and images the focus by sending it `-lockFocus` and `-unlockFocus` messages.

A view can have subviews. It is not necessary to explicitly draw the subviews in the `-drawRect:` method; this will be done automatically. It is also not necessary to call `super` in the `-drawRect:` method.

### Event handling & controllers

Events are handled by controllers. Each controller is linked to a view. It is possible to have a view without a controller, but not the other way around. Controllers are automatically generated for views: implement `-controllerClass` in the view and let it return the class of the controller.

#### Mouse events

Mouse events are sent immediately to the deepest subview.

When a view has successfully handled an event, the event should be discarded. When a view can't handle the specific event, the method handling the event should forward the event to the superview (which is what the default implementation does).

#### Key events

Key events are sent to the main view, unless there is a first responder, in which case the even will be sent immediately to the first responder.

When a view successfully handles an event, the event is discarded. When a view receiving a key event does not know how to handle it, it will sequentially forward the event to all of its subviews, until either it wasn't handled by any subviews, or it was handled by one subview, in which case the event will not be forwarded to the remaining subviews but will be discarded instead.

Relationships with Other Frameworks
-----------------------------------

### Cocoa

Monet is loosely inspired by Cocoa. Being loosely inspired means that Monet's behaviour does not always match Cocoa's. For example, event handling is much simpler than in Cocoa (because a system as complex as Cocoa's is not necessary).

### SDL

Monet uses SDL for window management and event handling. It also uses SDL_image for loading images in different formats. None of SDL's drawing functionality is used; this is where OpenGL comes in.

### OpenGL

Monet uses OpenGL for all drawing operations.

Other Implementations
---------------------

Even though Monet is built on top of SDL and OpenGL, it should be relatively easy to replace SDL or OpenGL with a different implementation. For example, replacing SDL with GLUT should be possible without affecting any public Monet interfaces; similarly, replacing OpenGL with SDL's built-in drawing functions should be possible in the same way.
