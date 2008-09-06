#import <Foundation/Foundation.h>

#import <Monet/Types.h>

#import <SDL/SDL.h>

typedef struct _MOColor {
	SDL_Color color;
} MOColor;

MOColor MOMakeColor(UInt8 aRed, UInt8 aGreen, UInt8 aBlue);
