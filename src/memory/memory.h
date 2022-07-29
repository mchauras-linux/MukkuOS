#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>

void* memset(void* ptr, int c, size_t size);
void *memcpy(void *restrict s1,
             const void *restrict s2,
             size_t n);
#endif