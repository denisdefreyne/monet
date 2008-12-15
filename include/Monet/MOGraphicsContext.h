#import <Foundation/Foundation.h>

#import <Monet/MORect.h>

@class MOImage;

@interface MOGraphicsContext : NSObject
{
	struct MOGraphicsContextData *graphicsContextData;
}

+ (NSMutableArray *)stack;
+ (MOGraphicsContext *)currentContext;

- (MORect)rect;

@end
