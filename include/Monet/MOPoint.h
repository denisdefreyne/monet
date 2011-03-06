#import <Foundation/Foundation.h>
#import <stdint.h>

typedef struct _MOPoint {
	int16_t x;
	int16_t y;
} MOPoint;

MOPoint MOPointMake(int16_t aX, int16_t aY);
