#import <Monet/MOView.h>

@interface MOButton : MOView
{
	BOOL isMouseDown;
	BOOL isMouseInside;
}

- (BOOL)isPressed;

- (void)clicked;

@end
