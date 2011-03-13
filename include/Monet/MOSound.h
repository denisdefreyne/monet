#import <Foundation/Foundation.h>

@interface MOSound : NSObject
{
	struct MOSoundData *soundData;
}

+ (MOSound *)named: (NSString *)aName;

- (void)play;

@end
