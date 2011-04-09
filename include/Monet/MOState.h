#import <Foundation/Foundation.h>
#import <Monet/Monet.h>

@interface MOState : NSObject <MOTicking>
{
	struct MOStateData *stateData;
}

+ (Class)viewClass;

- (id)initWithApp: (MOApplication *)aApp;

- (NSObject <MOTicking> *)world;
- (void)setWorld: (NSObject <MOTicking> *)aWorld;
- (MOView *)view;
- (MOController *)controller;

@end
