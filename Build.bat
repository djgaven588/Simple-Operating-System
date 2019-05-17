@echo off
cd Source
@echo on
"../nasm/nasm" -fbin bootloader.asm -o ../Build/bootloader.bin
"../nasm/nasm" -fbin kernal.asm -o ../Build/kernal.bin
@echo off
cd ../Build
@echo on
type "bootloader.bin" "kernal.bin" > complete.bin
del "first.iso"
@echo off
cd ../
@echo on
"cdrtools/mkisofs" -no-emul-boot -boot-load-size 4 -o Build/first.iso -b complete.bin Build/
pause