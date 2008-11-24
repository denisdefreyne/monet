#import <Foundation/Foundation.h>

#import <Monet/Types.h>

typedef struct _MOColor {
	float red;
	float green;
	float blue;
} MOColor;

MOColor MOMakeColor(float aRed, float aGreen, float aBlue);
