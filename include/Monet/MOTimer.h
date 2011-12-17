typedef struct _MOTimer MOTimer;

MOTimer *MOTimerCreate(double aDuration, void *aUserInfo);

double MOTimerGetDuration(MOTimer *aTimer);
void *MOTimerGetUserInfo(MOTimer *aTimer);

void MOTimerStart(MOTimer *aTimer);
void MOTimerStop(MOTimer *aTimer);
