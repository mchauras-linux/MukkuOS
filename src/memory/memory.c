#include "memory.h"

void* memset(void* ptr, int c, size_t size) {
    char * ch_ptr = (char *) ptr;
    for (size_t i = 0; i < size; i++)
    {
        ch_ptr[i] = (char) c;
    }
    return ptr;
}

void *memcpy(void *restrict s1,
             const void *restrict s2,
             size_t n)
{
    for (register size_t i = 0; i < n; i++)
    {
        *((char *)s1 + i) = *(char *)(s2 + i);
    }
    return s1;
}