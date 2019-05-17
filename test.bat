::"qemu/bin/qemu-system-gnuarmeclipse.exe" -help
"qemu/bin/qemu-system-gnuarmeclipse.exe" -boot d -cdrom Build/first.iso -m 512 -mcu pc-q35-2.8
::"qemu/bin/qemu-system-gnuarmeclipse.exe" -fda "Build/complete.bin"
pause