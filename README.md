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