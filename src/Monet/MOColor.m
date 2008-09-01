#import <Monet/MOColor.h>

MOColor MOMakeColor(UInt8 aRed, UInt8 aGreen, UInt8 aBlue)
{
	MOColor color;

	color.color.r = aRed;
	color.color.g = aGreen;
	color.color.b = aBlue;

	return color;
}
