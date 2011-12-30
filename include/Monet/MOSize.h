#ifndef __MONET_MOSIZE_H__
#define __MONET_MOSIZE_H__

#include <Monet/Common.h>

typedef vec2_t MOSize;

static inline MOSize MOSizeMake(uint16_t aW, uint16_t aH)
{
	return vec2_create(aW, aH);
}

#endif
