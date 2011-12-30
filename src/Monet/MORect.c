#include <Monet/MORect.h>

#include <Monet/Common.h>

#include <Monet/MOColor.h>
#include <Monet/MOGraphicsContext.h>
#include <Monet/Private.h>

// FIXME this does not take the graphics context into account
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
	MORect dstRect = MOGraphicsContext_getCurrentRect();
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
