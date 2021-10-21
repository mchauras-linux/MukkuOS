ORG 0
BITS 16

jmp 0x7c0:start

start:
    cli ; Clear Interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables Interrupts
    mov si, message
    call print
    jmp $

;Print message stored in SI register
print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret
;Print Character
print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Booting Mukku OS...', 0
times 510 - ($ - $$) db 0
db 0x55
db 0xAA