#import <Foundation/Foundation.h>

#import <Monet/MOColor.h>
#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

#import <OpenGL/gl.h>

@class MOImage;

@interface MOGraphicsContext : NSObject
{
	GLuint		textureName;
	MORect		rect;
}

+ (NSMutableArray *)stack;
+ (MOGraphicsContext *)currentContext;

- (MORect)rect;

@end
