#ifndef __MONET_MOCOLOR_H__
#define __MONET_MOCOLOR_H__

struct _MOColor
{
	double r, g, b, a;
};
typedef struct _MOColor MOColor;

MOColor MOColorMakeRGB(double aRed, double aGreen, double aBlue);
MOColor MOColorMakeRGBA(double aRed, double aGreen, double aBlue, double aAlpha);

#endif
