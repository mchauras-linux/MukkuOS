ORG 0x7C00

BITS 16

start:
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

message: db 'Mukku OS', 0
times 510 - ($ - $$) db 0
db 0x55
db 0xAA