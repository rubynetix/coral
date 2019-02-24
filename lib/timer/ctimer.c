#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include "ctimer.h"

void delay(long seconds, long nanoseconds) {
	struct timespec ts;
	ts.tv_sec = seconds;
	ts.tv_nsec = nanoseconds;
	nanosleep(&ts, NULL);
}
