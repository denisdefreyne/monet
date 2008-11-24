#import <Foundation/Foundation.h>

// FIXME remove these headers
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

@class MOGraphicsContext;

@interface MOImage : NSObject
{
	GLuint				textureName;

	MOSize				size;

	MOGraphicsContext	*graphicsContext;
}

- (id)initWithContentsOfFile:(NSString *)aFilename;
- (id)initWithWidth:(UInt16)aWidth height:(UInt16)aHeight;

- (void)lockFocus;
- (void)unlockFocus;

- (MORect)bounds;

- (void)takeImageFromRect:(MORect)aRect;

- (void)drawAtPoint:(MOPoint)aPoint;

@end
