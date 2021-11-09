all:
	nasm -f bin -g boot.asm -o boot.bin
	dd if=message.txt >> boot.bin
	dd if=/dev/zero bs=512 count=1 >> boot.bin

run: all
	qemu-system-x86_64 -hda boot.bin

clean:
	rm -rf boot.bin