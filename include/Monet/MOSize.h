#import <Foundation/Foundation.h>
#import <stdint.h>

typedef struct _MOSize {
	uint16_t w;
	uint16_t h;
} MOSize;

MOSize MOSizeMake(uint16_t aW, uint16_t aH);
