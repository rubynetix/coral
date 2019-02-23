%module ctimer
%{
#include "ctimer.h"
%}

void countdown(int nanoseconds, char *expiration_msg);