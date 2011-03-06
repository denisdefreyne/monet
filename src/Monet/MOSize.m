#import <Monet/MOSize.h>

MOSize MOSizeMake(uint16_t aW, uint16_t aH)
{
	MOSize size;

	size.w	= aW;
	size.h	= aH;

	return size;
}
