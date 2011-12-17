#import <Monet/MOGraphicsContext.h>

#import <Monet/Private.h>

NSMutableArray *MOGraphicsContext_getStack(void)
{
	static NSMutableArray *stack = nil;

	if (!stack)
		stack = [[NSMutableArray alloc] init];

	return stack;
}

MOGraphicsContext *MOGraphicsContext_getCurrent(void)
{
	return [[MOGraphicsContext_getStack() lastObject] pointerValue];
}

MORect MOGraphicsContext_getCurrentRect(void)
{
	return MOGraphicsContextGetRect(
		MOGraphicsContext_getCurrent());
}

void MOGraphicsContext_push(MOGraphicsContext *aGraphicsContext)
{
	[MOGraphicsContext_getStack() addObject: [NSValue valueWithPointer: aGraphicsContext]];
}

void MOGraphicsContext_pop(void)
{
	[MOGraphicsContext_getStack() removeLastObject];
}

MORect MOGraphicsContextGetRect(MOGraphicsContext *aGraphicsContext)
{
	return aGraphicsContext->rect;
}
