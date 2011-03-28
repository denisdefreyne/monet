#import <Foundation/Foundation.h>
#import <stdint.h>

@interface MOTimer : NSObject
{
	struct MOTimerData *timerData;
}

- (id)initWithDuration: (double)aDuration userInfo: (void *)aUserInfo;

- (double)duration;
- (void *)userInfo;

- (void)start;
- (void)stop;

@end
