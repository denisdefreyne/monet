#import <Monet/MOSound.h>

#import <SDL_mixer.h>

struct MOSoundData
{
	Mix_Chunk *chunk;
};

@implementation MOSound

- (id)initWithFilename: (NSString *)aName
{
	if ((self = [super init]))
	{
		soundData = calloc(1, sizeof (struct MOSoundData));

		soundData->chunk = Mix_LoadWAV([aName UTF8String]);
	}

	return self;
}

- (void)dealloc
{
	Mix_FreeChunk(soundData->chunk);

	[super dealloc];
}

#pragma mark -

+ (MOSound *)named: (NSString *)aName
{
	return [[[self alloc] initWithFilename: aName] autorelease];
}

#pragma mark -

- (void)play
{
	int channel = Mix_PlayChannel(-1, soundData->chunk, 0);
}

@end
