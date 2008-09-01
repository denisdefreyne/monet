#import <Foundation/Foundation.h>

#import <Monet/MOColor.h>
#import <Monet/MOPoint.h>
#import <Monet/MOSize.h>

typedef SDL_Rect MORect;

MORect MOMakeRect(SInt16 aX, SInt16 aY, UInt16 aW, UInt16 aH);

void MOFillRect(MORect aRect, MOColor aColor);
