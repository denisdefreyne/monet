#import <Foundation/Foundation.h>

#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

@interface MOImage : NSObject
{
	struct MOImageData *imageData;
}

- (id)initWithContentsOfFile: (NSString *)aFilename;
- (id)initWithWidth: (uint16_t)aWidth height: (uint16_t)aHeight;

- (void)lockFocus;
- (void)unlockFocus;

- (MORect)bounds;

// FIXME allow drawing into a MOImage instead
- (void)takeImageFromRect: (MORect)aRect;

- (void)drawAtPoint: (MOPoint)aPoint;

@end
