#import <Monet/MOSize.h>

MOSize MOMakeSize(UInt16 aWidth, UInt16 aHeight)
{
	MOSize size;

	size.width	= aWidth;
	size.height	= aHeight;

	return size;
}
