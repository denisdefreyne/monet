#ifndef __MONET_MOSOUND_H__
#define __MONET_MOSOUND_H__

typedef struct _MOSound MOSound;

MOSound *MOSoundCreateFromFilename(char *aFilename);
void MOSoundPlay(MOSound *aSound);

#endif
