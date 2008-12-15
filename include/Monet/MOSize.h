#import <Foundation/Foundation.h>

#import <Monet/Types.h>

typedef struct _MOSize {
	UInt16 w;
	UInt16 h;
} MOSize;

MOSize MOSizeMake(UInt16 aW, UInt16 aH);
