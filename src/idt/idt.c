#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "kernel/kernel.h"

struct idt_desc idt_descriptors[MUKKUOS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;

extern void load_idt(struct idtr_desc* ptr);

void idt_zero() 
{
    print("Divide by Zero Error\n");
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

    //Load Interrupt Descriptor Table
    load_idt(&idtr_descriptor);
    idt_set(0, idt_zero);
}
