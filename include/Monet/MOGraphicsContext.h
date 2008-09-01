#import <Foundation/Foundation.h>

#import <Monet/MOColor.h>
#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

@class MOImage;

@interface MOGraphicsContext : NSObject
{
	SDL_Surface	*surface;
	MORect		rect;
}

+ (NSMutableArray *)stack;
+ (MOGraphicsContext *)currentContext;

- (MORect)rect;

@end
