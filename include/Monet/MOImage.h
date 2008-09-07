#import <Foundation/Foundation.h>

#import <SDL/SDL.h>

#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

typedef enum _MOTransparencyType {
	MOOpaqueTransparencyType,
	MOAlphaChannelTransparencyType,
	MOColorKeyTransparencyType
} MOTransparencyType;

@class MOGraphicsContext;

@interface MOImage : NSObject
{
	SDL_Surface			*surface;

	MOGraphicsContext	*graphicsContext;
}

- (id)initWithContentsOfFile:(NSString *)aFilename;
- (id)initWithContentsOfFile:(NSString *)aFilename transparencyType:(MOTransparencyType)aTransparencytype;
- (id)initWithWidth:(UInt16)aWidth height:(UInt16)aHeight;

- (void)lockFocus;
- (void)unlockFocus;

- (MORect)bounds;

- (void)drawAtPoint:(MOPoint)aPoint;

@end
