#include "kernel.h"
#include "terminal.h"
#include "idt/idt.h"
#include <stdint.h>
#include <stddef.h>

void kernel_main() 
{
    //Init Terminal
    terminalInit();

    print("Mukku OS\nHello World\n");

    //Init IDT
    idt_init();

    //Enable Interrupts
    enable_interrupts();
}

