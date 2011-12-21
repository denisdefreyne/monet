#ifndef __MONET_MOSIZE_H__
#define __MONET_MOSIZE_H__

#include <SeaBase/Types.h>

struct _MOSize {
	uint16_t w;
	uint16_t h;
};
typedef struct _MOSize MOSize;

MOSize MOSizeMake(uint16_t aW, uint16_t aH);

#endif
