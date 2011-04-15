#import <Monet/MOView.h>

@interface MOButton : MOView
{
	struct MOButtonData *buttonData;
}

- (void)clicked;

@end
