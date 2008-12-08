#import <Foundation/Foundation.h>

#import <Monet/MOColor.h>
#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

@class MOImage;

@interface MOGraphicsContext : NSObject
{
@protected
	struct MOGraphicsContextData *graphicsContextData;
}

+ (NSMutableArray *)stack;
+ (MOGraphicsContext *)currentContext;

- (MORect)rect;

@end
