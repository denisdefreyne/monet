#import <Monet/MOPoint.h>
#import <Monet/MORect.h>
#import <Monet/MOSize.h>

typedef struct _MOImage MOImage;

MOImage *MOImageCreateFromFile(char *aFilename);
MOImage *MOImageCreateWithSize(MOSize aSize);

void MOImageLockFocus(MOImage *aImage);
void MOImageUnlockFocus(MOImage *aImage);

MORect MOImageGetBounds(MOImage *aImage);

// FIXME allow drawing into a MOImage instead
void MOImageTakeFromOnScreenRect(MOImage *aImage, MORect aRect);

void MOImageDrawAtPoint(MOImage *aImage, MOPoint aPoint);
