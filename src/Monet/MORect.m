#import <Monet/MORect.h>

#import <SDL/SDL.h>

#import <Monet/MOColor.h>
#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

MORect MOMakeRect(SInt16 aX, SInt16 aY, UInt16 aWidth, UInt16 aHeight)
{
	MORect rect;

	rect.origin.x		= aX;
	rect.origin.y		= aY;
	rect.size.width		= aWidth;
	rect.size.height	= aHeight;

	return rect;
}

SInt16 MOMinX(MORect aRect)
{
	return aRect.origin.x;
}

SInt16 MOMaxX(MORect aRect)
{
	return aRect.origin.x + aRect.size.width;
}

SInt16 MOMinY(MORect aRect)
{
	return aRect.origin.y;
}

SInt16 MOMaxY(MORect aRect)
{
	return aRect.origin.y + aRect.size.height;
}

#ifndef MAX
#define MAX(a, b) ({typeof(a) _a = (a); typeof(b) _b = (b); _a > _b ? _a : _b; })
#endif

#ifndef MIN
#define MIN(a, b) ({typeof(a) _a = (a); typeof(b) _b = (b);	_a < _b ? _a : _b; })
#endif

MORect MOIntersectionRect(MORect aRect1, MORect aRect2)
{
	MORect rect;

	// Check whether rects really intersect
	if(	MOMaxX(aRect1) <= MOMinX(aRect2) ||
		MOMaxX(aRect2) <= MOMinX(aRect1) ||
		MOMaxY(aRect1) <= MOMinY(aRect2) ||
		MOMaxY(aRect2) <= MOMinY(aRect1))
		return MOMakeRect(0, 0, 0, 0);

	if(MOMinX(aRect1) <= MOMinX(aRect2))
	{
		rect.size.width = MIN(MOMaxX(aRect1), MOMaxX(aRect2)) - MOMinX(aRect2);
		rect.origin.x = MOMinX(aRect2);
	}
	else
	{
		rect.size.width = MIN(MOMaxX(aRect1), MOMaxX(aRect2)) - MOMinX(aRect1);
		rect.origin.x = MOMinX(aRect1);
	}
	
	if(MOMinY(aRect1) <= MOMinY(aRect2))
	{
		rect.size.height = MIN(MOMaxY(aRect1), MOMaxY(aRect2)) - MOMinY(aRect2);
		rect.origin.y = MOMinY(aRect2);
	}
	else
	{
		rect.size.height = MIN(MOMaxY(aRect1), MOMaxY(aRect2)) - MOMinY(aRect1);
		rect.origin.y = MOMinY(aRect1);
	}

	return rect;
}

void MOFillRect(MORect aRect, MOColor aColor)
{
	// Get surface and clip rect
	MOGraphicsContext	*graphicsContext	= [MOGraphicsContext currentContext];
	SDL_Surface			*surface			= [graphicsContext surface];
	MORect				rect				= [graphicsContext rect];

	// Update draw rect
	aRect.origin = rect.origin;

	// Clip
	MORect clippedRect = MOIntersectionRect(aRect, rect);
	SDL_Rect sdlRect;
	sdlRect.x = clippedRect.origin.x;
	sdlRect.y = clippedRect.origin.y;
	sdlRect.w = clippedRect.size.width;
	sdlRect.h = clippedRect.size.height;

	// Convert color
	Uint32 sdlColor = SDL_MapRGB(surface->format, aColor.color.r, aColor.color.g, aColor.color.b);

	// Fill
	SDL_FillRect(surface, &sdlRect, sdlColor);
}
