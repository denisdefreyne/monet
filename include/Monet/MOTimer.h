#import <Foundation/Foundation.h>
#import <stdint.h>

@interface MOTimer : NSObject
{
	struct MOTimerData *timerData;
}

- (id)initWithTarget: (id)aTarget selector: (SEL)aSelector interval: (uint32_t)aInterval userInfo: (void *)aUserInfo;

- (id)target;
- (SEL)selector;
- (uint32_t)interval;
- (void *)userInfo;

- (void)start;
- (void)stop;

@end
