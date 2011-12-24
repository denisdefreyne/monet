#ifndef __MONET_MOSOUND_H__
#define __MONET_MOSOUND_H__

#include <Monet/Common.h>

typedef struct _MOSound MOSound;

extern COClass MOSoundClass;

MOSound *MOSoundCreateFromFilename(char *aFilename);
void MOSoundPlay(MOSound *aSound);

#endif
