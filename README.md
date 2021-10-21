# MukkuOS

To compile boot.asm use nasm compiler

command =>
nasm -f bin boot.asm -o boot.bin

Use QEMU as Simulator

command =>
qemu-system-x86_64 boot.bin