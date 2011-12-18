#import <Foundation/Foundation.h>

#import <Monet/MOApplication.h>
#import <Monet/MOTicking.h>
#import <Monet/MOView.h>

@interface MOState : NSObject <MOTicking>
{
	struct MOStateData *stateData;
}

+ (Class)viewClass;

- (id)initWithApp: (MOApplication *)aApp view: (MOView *)aView;

- (NSObject <MOTicking> *)world;
- (void)setWorld: (NSObject <MOTicking> *)aWorld;
- (MOView *)view;

@end
