#import <Monet/MOSize.h>

MOSize MOMakeSize(UInt16 aW, UInt16 aH)
{
	MOSize size;

	size.w	= aW;
	size.h	= aH;

	return size;
}
