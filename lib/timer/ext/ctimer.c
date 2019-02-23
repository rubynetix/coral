#include <stdio.h>
#include <unistd.h>
#include "ctimer.h"

void countdown(int nanoseconds, char *expiration_msg) {
    // TODO: Replace sleep with nanosecond timer implementation
    sleep(5);

    printf("%s\n", expiration_msg);
}