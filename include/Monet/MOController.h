#import <Foundation/Foundation.h>

#import <Monet/MOTicking.h>

@class MOApplication;
@class MOEvent;
@class MOTimer;
@class MOView;

@interface MOController : NSObject <MOTicking>
{
	struct MOControllerData *controllerData;
}

- (id)initWithView: (MOView *)aView;

- (MOApplication *)app;
- (MOView *)view;

- (BOOL)keyDown: (MOEvent *)aEvent;
- (BOOL)keyUp: (MOEvent *)aEvent;
- (void)mouseDown: (MOEvent *)aEvent;
- (void)mouseUp: (MOEvent *)aEvent;
- (void)mouseDragged: (MOEvent *)aEvent;
- (void)timerFired: (MOEvent *)aEvent;

@end
