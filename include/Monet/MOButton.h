#import <Foundation/Foundation.h>

#import <Monet/MOView.h>

@interface MOButton : MOView
{
@protected
	struct MOButtonData *buttonData;
}

- (BOOL)isPressed;

- (void)clicked;

@end
