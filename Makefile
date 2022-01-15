OS_NAME=mukkuOs
FILES = ./build/kernel.asm.o
DEBUG_FLAGS=-g

all: ./bin/boot.bin ./bin/kernel.bin
	dd if=./bin/boot.bin > ./bin/$(OS_NAME).bin
	dd if=./bin/kernel.bin >> ./bin/$(OS_NAME).bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/$(OS_NAME).bin

./bin/boot.bin: ./src/boot/boot.asm
	nasm -f bin $(DEBUG_FLAGS) ./src/boot/boot.asm -o ./bin/boot.bin

./bin/kernel.bin: $(FILES)
	i686-elf-ld $(DEBUG_FLAGS) -relocatable $(FILES) -o ./build/$(OS_NAME).o
	i686-elf-gcc -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/$(OS_NAME).o

./build/kernel.asm.o: ./src/kernel.asm
	nasm -f elf $(DEBUG_FLAGS) ./src/kernel.asm -o ./build/kernel.asm.o

run: all
	qemu-system-x86_64 -hda ./bin/$(OS_NAME).bin

clean:
	rm -rf ./build/*
	rm -rf ./bin/*