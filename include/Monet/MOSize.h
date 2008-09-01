#import <Foundation/Foundation.h>

typedef struct _MOSize {
	UInt16	w;
	UInt16	h;
} MOSize;

MOSize MOMakeSize(UInt16 aW, UInt16 aH);
