#include <Monet/MOColor.h>

MOColor MOColorMakeRGB(double aRed, double aGreen, double aBlue)
{
	MOColor color;

	color.r = aRed;
	color.g = aGreen;
	color.b = aBlue;
	color.a = 1.0l;

	return color;
}

MOColor MOColorMakeRGBA(double aRed, double aGreen, double aBlue, double aAlpha)
{
	MOColor color;

	color.r = aRed;
	color.g = aGreen;
	color.b = aBlue;
	color.a = aAlpha;

	return color;
}
