#include <Monet/MOSound.h>

#include <cobject/cobject.h>
#include <SDL_mixer.h>

struct _MOSound
{
	COGuts    *guts;

	Mix_Chunk *chunk;
};

void _MOSoundDestroy(void *aSound);

MOSound *MOSoundCreateFromFilename(char *aFilename)
{
	MOSound *sound = malloc(sizeof (MOSound));
	COInitialize(sound);
	COSetDestructor(sound, &_MOSoundDestroy);

	sound->chunk = Mix_LoadWAV(aFilename);

	return sound;
}

void _MOSoundDestroy(void *aSound)
{
	MOSound *sound = (MOSound *)aSound;

	Mix_FreeChunk(sound->chunk);
}

void MOSoundPlay(MOSound *aSound)
{
	Mix_PlayChannel(-1, aSound->chunk, 0);
}
