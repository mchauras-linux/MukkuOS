#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "kernel/kernel.h"
#include "io/io.h"
#include "kernel/terminal.h"

struct idt_desc idt_descriptors[MUKKUOS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;

extern void load_idt(struct idtr_desc* ptr);
extern void no_interrupt();

extern void idt_zero();

extern void int20h();
extern void int21h();

void no_interrupt_handler()
{
    //print("No Interrupt Handler\n");
    outb(0x20, 0x20);
}

/**
 * @brief Interrupt handler for Timer Interrupt
 * 
 */
void int20h_handler()
{
    //print("Timer Interrupt\n");
    outb(0x20, 0x20);
}

void int21h_handler()
{
    print("Keyboard Pressed\n");
    outb(0x20, 0x20);
}

void idt_zero_handler() 
{
    print("Divide by Zero Error\n");
    outb(0x20, 0x20);
}

void idt_set(int int_no, void* address)
{
    struct idt_desc* desc = &idt_descriptors[int_no];
    desc->offset_1 = (uint32_t) address & 0x0000FFFF;
    desc->selector = KERNEL_CODE_SELECTOR;
    desc->zero = 0;
    desc->type_attr = 0xEE;
    desc->offset_2 = (uint32_t) address >> 16;
}

void idt_init()
{
    memset(idt_descriptors, 0, sizeof(idt_descriptors));
    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptor.base = (uint32_t) idt_descriptors;

    for(int i = 0; i < MUKKUOS_TOTAL_INTERRUPTS; i++)
    {
        idt_set(i, no_interrupt);
    }

    idt_set(0, idt_zero);
    idt_set(0x20, int20h);
    idt_set(0x21, int21h);

    //Load Interrupt Descriptor Table
    load_idt(&idtr_descriptor);
}
