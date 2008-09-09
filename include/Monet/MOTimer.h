#import <Foundation/Foundation.h>

#import <SDL/SDL.h>

@interface MOTimer : NSObject
{
	SDL_TimerID	timerID;

	UInt32		interval;

	id			target;
	SEL			selector;

	void		*userInfo;
}

- (id)initWithTarget:(id)aTarget selector:(SEL)aSelector interval:(UInt32)aInterval userInfo:(void *)aUserInfo;

- (id)target;
- (SEL)selector;
- (UInt32)interval;
- (void *)userInfo;

- (void)start;
- (void)stop;

@end
