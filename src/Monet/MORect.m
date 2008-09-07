#import <Monet/MORect.h>

#import <SDL/SDL.h>

#import <Monet/MOColor.h>
#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

MORect MOMakeRect(SInt16 aX, SInt16 aY, UInt16 aW, UInt16 aH)
{
	MORect rect = { aX, aY, aW, aH };
	return rect;
}

void MOFillRect(MORect aRect, MOColor aColor)
{
	// Get surface and clip rect
	MOGraphicsContext	*graphicsContext	= [MOGraphicsContext currentContext];
	SDL_Surface			*surface			= [graphicsContext surface];
	MORect				rect				= [graphicsContext rect];

	// Translate source rect
	aRect.x += rect.x;
	aRect.y += rect.y;

	// Convert color
	Uint32 sdlColor = SDL_MapRGB(surface->format, aColor.color.r, aColor.color.g, aColor.color.b);

	// Fill
	SDL_SetClipRect(surface, &rect);
	SDL_FillRect(surface, &aRect, sdlColor);
	SDL_SetClipRect(surface, NULL);
}

void MOStrokeRect(MORect aRect, MOColor aColor)
{
	MOFillRect(MOMakeRect(aRect.x,					aRect.y,				aRect.w,	1		), aColor);
	MOFillRect(MOMakeRect(aRect.x,					aRect.y,				1,			aRect.h	), aColor);
	MOFillRect(MOMakeRect(aRect.x,					aRect.y + aRect.h - 1,	aRect.w,	1		), aColor);
	MOFillRect(MOMakeRect(aRect.x + aRect.w - 1,	aRect.y,				1,			aRect.h	), aColor);
}

BOOL MORectContainsPoint(MORect aRect, MOPoint aPoint)
{
	return	(aPoint.x >= aRect.x && aPoint.x < aRect.x + aRect.w) &&
			(aPoint.y >= aRect.y && aPoint.y < aRect.y + aRect.h);
}
