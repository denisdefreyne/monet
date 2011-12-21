#include <Monet/MOGraphicsContext.h>

#include <Monet/Private.h>

SBArray *MOGraphicsContext_getStack(void)
{
	static SBArray *stack = NULL;

	if (!stack)
		stack = SBArrayCreateWithCapacity(5);

	return stack;
}

MOGraphicsContext *MOGraphicsContext_getCurrent(void)
{
	return SBArrayPeek(MOGraphicsContext_getStack());
}

MORect MOGraphicsContext_getCurrentRect(void)
{
	return MOGraphicsContextGetRect(
		MOGraphicsContext_getCurrent());
}

void MOGraphicsContext_push(MOGraphicsContext *aGraphicsContext)
{
	return SBArrayPush(MOGraphicsContext_getStack(), aGraphicsContext);
}

void MOGraphicsContext_pop(void)
{
	SBArrayPop(MOGraphicsContext_getStack());
}

MORect MOGraphicsContextGetRect(MOGraphicsContext *aGraphicsContext)
{
	return aGraphicsContext->rect;
}
