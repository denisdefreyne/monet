#import <Foundation/Foundation.h>

#import <Monet/MOApplication.h>
#import <Monet/MOTicking.h>

@class MOView;

@interface MOState : NSObject <MOTicking>
{
	struct MOStateData *stateData;
}

+ (Class)viewClass;

- (id)initWithApp: (MOApplication *)aApp;

- (NSObject <MOTicking> *)world;
- (void)setWorld: (NSObject <MOTicking> *)aWorld;
- (MOView *)view;

@end
