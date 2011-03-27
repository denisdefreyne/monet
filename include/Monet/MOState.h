#import <Foundation/Foundation.h>
#import <Monet/Monet.h>

@interface MOState : NSObject
{
	struct MOStateData *stateData;
}

+ (Class)viewClass;

- (id)initWithApp: (MOApplication *)aApp;

- (MOView *)view;
- (MOController *)controller;

@end
