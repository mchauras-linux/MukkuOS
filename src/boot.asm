ORG 0x7C00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop
times 33 db 0

start:
    jmp 0:step2

read_hdd:
    mov ah, 2       ; Read Sector command
    mov al, 2       ; Two Sector to read
    mov ch, 0       ; Cylinder low eight bits
    mov cl, 2       ; Read Sector 2
    mov dh, 0       ; Head Number
    mov bx, buffer
    int 0x13
    jc error
    ret

error:
    mov si, error_message
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
    cmp al, 0x0A
    je print_new_line
    mov ah, 0eh
    int 0x10
    ret

print_new_line:
    mov al, 0x0A
    mov ah, 0eh
    int 0x10
    mov al, 0x0D        ; Carriage Return
    int 0x10
    ret

step2:
    cli             ; Clear Interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti             ; Enables Interrupts

    call read_hdd   ; Read Booting Message
    mov si, buffer
    call print

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

error_message: db 'Failed to read HDD', 0

;GDT
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0
; offset 0x8
gdt_code:     ; CS SHOULD POINT TO THIS
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0      ; Base first 0-15 bits
    db 0      ; Base 16-23 bits
    db 0x9a   ; Access byte
    db 11001111b ; High 4 bit flags and the low 4 bit flags
    db 0        ; Base 24-31 bits

; offset 0x10
gdt_data:      ; DS, SS, ES, FS, GS
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0      ; Base first 0-15 bits
    db 0      ; Base 16-23 bits
    db 0x92   ; Access byte
    db 11001111b ; High 4 bit flags and the low 4 bit flags
    db 0        ; Base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start-1
    dd gdt_start

;[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    jmp $

times 510 - ($ - $$) db 0
db 0x55
db 0xAA

buffer: