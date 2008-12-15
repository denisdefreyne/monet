#import <Foundation/Foundation.h>

#import <Monet/Types.h>

@interface MOColor : NSObject
{
	struct MOColorData *colorData;
}

- (id)initWithRed:(double)aRed green:(double)aGreen blue:(double)aBlue alpha:(double)alpha;
- (id)initWithRed:(double)aRed green:(double)aGreen blue:(double)aBlue;

- (double)red;
- (double)green;
- (double)blue;
- (double)alpha;

@end
