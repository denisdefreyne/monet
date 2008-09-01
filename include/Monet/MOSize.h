#import <Foundation/Foundation.h>

typedef struct _MOSize {
	UInt16	width;
	UInt16	height;
} MOSize;

MOSize MOMakeSize(UInt16 aWidth, UInt16 aHeight);
