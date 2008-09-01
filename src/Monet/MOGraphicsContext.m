#import <Monet/MOGraphicsContext.h>

@implementation MOGraphicsContext

+ (NSMutableArray *)stack
{
	static NSMutableArray *stack = nil;

	if(!stack)
		stack = [[NSMutableArray alloc] init];

	return stack;
}

+ (MOGraphicsContext *)currentContext
{
	return [[self stack] lastObject];
}

#pragma mark -

- (MORect)rect
{
	return rect;
}

@end
