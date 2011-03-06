#import <Monet/MOColor.h>

struct MOColorData
{
	double red;
	double green;
	double blue;
	double alpha;
};

@implementation MOColor

- (id)initWithRed: (double)aRed green: (double)aGreen blue: (double)aBlue alpha: (double)aAlpha
{
	if (self = [super init])
	{
		// Create data
		colorData = calloc(1, sizeof (struct MOColorData));

		// Set values
		colorData->red   = aRed;
		colorData->green = aGreen;
		colorData->blue  = aBlue;
		colorData->alpha = aAlpha;
	}

	return self;
}

- (id)initWithRed: (double)aRed green: (double)aGreen blue: (double)aBlue
{
	return [self initWithRed: aRed green: aGreen blue: aBlue alpha: 1.0];
}

#pragma mark -

- (double)red
{
	return colorData->red;
}

- (double)green
{
	return colorData->green;
}

- (double)blue
{
	return colorData->blue;
}

- (double)alpha
{
	return colorData->alpha;
}

@end
