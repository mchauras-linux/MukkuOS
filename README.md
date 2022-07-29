# MukkuOS

To compile boot.asm use nasm compiler

command =>
nasm -f bin boot.asm -o boot.bin

Use QEMU as Simulator

command =>
qemu-system-x86_64 boot.bin

Setup Cross Compiler =>
Google Osdev Wiki GCC Cross Compiler
This will setup binutils and gcc cross compiler

Debug via gdb =>

gdb
add-symbol-file ./build/kernel.a 0x100000
set breakpoint
break kernel_main
target remote | qemu-system-x86_64 -S -gdb stdio -hda ./bin/mukku.bin