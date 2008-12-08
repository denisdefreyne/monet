#import <Foundation/Foundation.h>

#import <Monet/Types.h>

@interface MOTimer : NSObject
{
	struct MOTimerData *timerData;
}

- (id)initWithTarget:(id)aTarget selector:(SEL)aSelector interval:(UInt32)aInterval userInfo:(void *)aUserInfo;

- (id)target;
- (SEL)selector;
- (UInt32)interval;
- (void *)userInfo;

- (void)start;
- (void)stop;

@end
