OS_NAME=mukku
FILES = ./build/kernel.asm.o ./build/kernel.o
INCLUDES= -I./src
DEBUG_FLAGS=-g
CFLAGS= $(DEBUG_FLAGS) -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: ./bin/boot.bin ./bin/kernel.bin
	dd if=./bin/boot.bin > ./bin/$(OS_NAME).bin
	dd if=./bin/kernel.bin >> ./bin/$(OS_NAME).bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/$(OS_NAME).bin

./bin/boot.bin: ./src/boot/boot.asm
	nasm -f bin $(DEBUG_FLAGS) ./src/boot/boot.asm -o ./bin/boot.bin

./bin/kernel.bin: $(FILES)
	i686-elf-ld $(DEBUG_FLAGS) -relocatable $(FILES) -o ./build/kernel.a
	i686-elf-gcc $(CFLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernel.a

./build/kernel.asm.o: ./src/kernel/kernel.asm
	nasm -f elf $(DEBUG_FLAGS) ./src/kernel/kernel.asm -o ./build/kernel.asm.o

./build/kernel.o: ./src/kernel/kernel.c
	i686-elf-gcc $(INCLUDES) $(CFLAGS) -std=gnu99 -c ./src/kernel/kernel.c -o ./build/kernel.o

run: all
	qemu-system-x86_64 -hda ./bin/$(OS_NAME).bin

clean:
	rm -rf ./build/*
	rm -rf ./bin/*