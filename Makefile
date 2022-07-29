OS_NAME=mukku
FILES = ./build/kernel/kernel.asm.o ./build/kernel/kernel.o ./build/idt/idt.o ./build/memory/memory.o ./build/idt/idt.asm.o ./build/io/io.asm.o ./build/kernel/terminal.o
INCLUDES= -I./src
DEBUG_FLAGS=-g
CFLAGS= $(DEBUG_FLAGS) -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: ./bin/boot.bin ./bin/kernel.bin
	dd if=./bin/boot.bin > ./bin/$(OS_NAME).bin
	dd if=./bin/kernel.bin >> ./bin/$(OS_NAME).bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/$(OS_NAME).bin

./bin/boot.bin: ./src/boot/boot.asm
	mkdir -p ./bin
	nasm -f bin $(DEBUG_FLAGS) ./src/boot/boot.asm -o ./bin/boot.bin

./bin/kernel.bin: $(FILES)
	i686-elf-ld $(DEBUG_FLAGS) -relocatable $(FILES) -o ./build/kernel.a
	i686-elf-gcc $(CFLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernel.a

./build/kernel/kernel.asm.o: ./src/kernel/kernel.asm
	mkdir -p ./build/kernel
	nasm -f elf $(DEBUG_FLAGS) ./src/kernel/kernel.asm -o ./build/kernel/kernel.asm.o

./build/kernel/kernel.o: ./src/kernel/kernel.c
	i686-elf-gcc $(INCLUDES) $(CFLAGS) -std=gnu99 -c ./src/kernel/kernel.c -o ./build/kernel/kernel.o

./build/kernel/terminal.o: ./src/kernel/terminal.c
	i686-elf-gcc $(INCLUDES) $(CFLAGS) -std=gnu99 -c ./src/kernel/terminal.c -o ./build/kernel/terminal.o

./build/idt/idt.o: ./src/idt/idt.c
	mkdir -p ./build/idt
	i686-elf-gcc $(INCLUDES) $(CFLAGS) -std=gnu99 -c ./src/idt/idt.c -o ./build/idt/idt.o

./build/idt/idt.asm.o: ./src/idt/idt.asm
	mkdir -p ./build
	nasm -f elf $(DEBUG_FLAGS) ./src/idt/idt.asm -o ./build/idt/idt.asm.o

./build/memory/memory.o: ./src/memory/memory.c
	mkdir -p ./build/memory
	i686-elf-gcc $(INCLUDES) $(CFLAGS) -std=gnu99 -c ./src/memory/memory.c -o ./build/memory/memory.o

./build/io/io.asm.o: ./src/io/io.asm
	mkdir -p ./build/io
	nasm -f elf $(DEBUG_FLAGS) ./src/io/io.asm -o ./build/io/io.asm.o

run: all
	qemu-system-i386 -hda ./bin/$(OS_NAME).bin

clean:
	rm -rf ./build
	rm -rf ./bin