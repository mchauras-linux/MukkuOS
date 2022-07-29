section .asm

global load_idt
global enable_interrupts
global disable_interrupts
global no_interrupt
extern no_interrupt_handler

global idt_zero
extern idt_zero_handler

global int20h
extern int20h_handler
global int21h
extern int21h_handler

enable_interrupts:
    sti
    ret

disable_interrupts:
    cli
    ret

load_idt:
    push ebp
    mov ebp,  esp
    mov ebx, [ebp + 8]
    lidt[ebx]
    pop ebp
    ret

no_interrupt:
    cli
    pushad
    call no_interrupt_handler
    popad
    sti
    iret

idt_zero:
    cli
    pushad
    call idt_zero_handler
    popad
    sti
    iret

int20h:
    cli
    pushad
    call int20h_handler
    popad
    sti
    iret

int21h:
    cli
    pushad
    call int21h_handler
    popad
    sti
    iret