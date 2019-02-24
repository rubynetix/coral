#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include "ctimer.h"

#define NS_PER_S 1000000000

void delay(long long nanoseconds) {
	struct timespec ts;
	ts.tv_sec = nanoseconds / NS_PER_S;
	ts.tv_nsec = nanoseconds % NS_PER_S;
	nanosleep(&ts, NULL);
}
