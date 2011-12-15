#import <Monet/MORect.h>

#import <SDL/SDL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import <Monet/MOColor.h>
#import <Monet/MOGraphicsContext.h>
#import <Monet/Private.h>

MORect MORectMake(int16_t aX, int16_t aY, uint16_t aW, uint16_t aH)
{
	MORect rect = { aX, aY, aW, aH };
	return rect;
}

void MORectFill(MORect aRect, MOColor aColor)
{
	// Save
	glPushAttrib(GL_CURRENT_BIT);

	// Draw
	glColor4f(aColor.r, aColor.g, aColor.b, aColor.a);
	glRecti(aRect.x, aRect.y, aRect.x + aRect.w, aRect.y + aRect.h);

	// Restore
	glPopAttrib();
}

void MORectStroke(MORect aRect, MOColor aColor)
{
	// Save
	glPushAttrib(GL_CURRENT_BIT);

	// Get absolute destination
	MORect dstRect = [[MOGraphicsContext currentContext] rect];
	aRect.x += dstRect.x;
	aRect.y += dstRect.y;

	// Draw
	glColor4f(aColor.r, aColor.g, aColor.b, aColor.a);
	glBegin(GL_LINE_LOOP);
	{
		glVertex2i(aRect.x,				aRect.y);
		glVertex2i(aRect.x + aRect.w,	aRect.y);
		glVertex2i(aRect.x + aRect.w,	aRect.y + aRect.h);
		glVertex2i(aRect.x,				aRect.y + aRect.h);
	}
	glEnd();

	// Restore
	glPopAttrib();
}

BOOL MORectContainsPoint(MORect aRect, MOPoint aPoint)
{
	return	(aPoint.x >= aRect.x && aPoint.x < aRect.x + aRect.w) &&
			(aPoint.y >= aRect.y && aPoint.y < aRect.y + aRect.h);
}

BOOL MORectIntersectsRect(MORect aRect1, MORect aRect2)
{
	if (aRect1.x + aRect1.w <= aRect2.x || aRect2.x + aRect2.w <= aRect1.x)
		return NO;

	if (aRect1.y + aRect1.h <= aRect2.y || aRect2.y + aRect2.h <= aRect1.y)
		return NO;

	return YES;
}
