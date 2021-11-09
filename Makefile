all:
	nasm -f bin -g ./src/boot.asm -o ./bin/boot.bin
	dd if=./src/data/boot_logo.txt >> ./bin/boot.bin
	dd if=/dev/zero bs=512 count=1 >> ./bin/boot.bin

run: all
	qemu-system-x86_64 -hda ./bin/boot.bin

clean:
	rm -rf ./build/*
	rm -rf ./bin/*