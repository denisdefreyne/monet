#import <Foundation/Foundation.h>

#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

@interface MOImage : NSObject
{
	struct MOImageData *imageData;
}

- (id)initWithContentsOfFile: (NSString *)aFilename;
- (id)initWithWidth: (UInt16)aWidth height: (UInt16)aHeight;

- (void)lockFocus;
- (void)unlockFocus;

- (MORect)bounds;

// FIXME allow drawing into a MOImage instead
- (void)takeImageFromRect: (MORect)aRect;

- (void)drawAtPoint: (MOPoint)aPoint;

@end
