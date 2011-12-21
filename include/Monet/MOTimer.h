#ifndef __MONET_MOTIMER_H__
#define __MONET_MOTIMER_H__

typedef struct _MOTimer MOTimer;

MOTimer *MOTimerCreate(double aDuration, void *aUserInfo);

double MOTimerGetDuration(MOTimer *aTimer);
void *MOTimerGetUserInfo(MOTimer *aTimer);

void MOTimerStart(MOTimer *aTimer);
void MOTimerStop(MOTimer *aTimer);

#endif
