#import <Monet/MOApplication.h>
#import <Monet/MORect.h>
#import <Monet/MOView.h>

typedef void (*MOButtonClickedCallback)(MOView *self);

MOView *MOButtonCreate(MORect aFrame, MOApplication *aApplication);

void MOButtonSetClickedCallback(MOView *self, MOButtonClickedCallback aCallback);
