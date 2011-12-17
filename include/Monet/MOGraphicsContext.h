#import <SeaBase/SeaBase.h>

#import <Monet/MORect.h>

typedef struct _MOGraphicsContext MOGraphicsContext;

SBArray *MOGraphicsContext_getStack(void);
MOGraphicsContext *MOGraphicsContext_getCurrent(void);
MORect MOGraphicsContext_getCurrentRect(void);

void MOGraphicsContext_push(MOGraphicsContext *aGraphicsContext);
void MOGraphicsContext_pop(void);

MORect MOGraphicsContextGetRect(MOGraphicsContext *aGraphicsContext);
