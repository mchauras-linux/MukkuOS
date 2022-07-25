#ifndef KERNEL_H
#define KERNEL_H
#include <stddef.h>
#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 20

void kernel_main();
void print(const char* str);

//Terminal Constants
uint16_t terminal_make_char(char c, char color);
void termianl_put_char(int x, int y,  char c, char color);
void terminal_writechar(char c, char color);
size_t strlen(const char* str);
void print(const char* str);
void terminal_init();

#endif