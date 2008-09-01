#import <Foundation/Foundation.h>

#import <SDL/SDL.h>

#import <Monet/MOPoint.h>
#import <Monet/MORect.h>

@class MOGraphicsContext;

@interface MOImage : NSObject
{
	SDL_Surface			*surface;

	MOGraphicsContext	*graphicsContext;
}

- (id)initWithContentsOfFile:(NSString *)aFilename;

- (void)lockFocus;
- (void)unlockFocus;

- (MORect)bounds;

- (void)drawAtPoint:(MOPoint)aPoint;

@end
