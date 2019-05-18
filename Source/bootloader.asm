; The bootloader
; The job of the boot loader is to load the kernal. That is all.
org 0x7C00

; Tell the compiler we are working in 16-bit mode. Real-mode
BITS 16

; Setup the stack
setup_stack:
    cli ; Disable interrupts for ss and sp. Required for <= 286
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00
    mov bp, sp
    sti

; Jump to the proper spot in memory that we should be at. Just in case
jmp 0x0000:start_16

start_16:
    ; initialise essential segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

; The next line is magic, don't touch it unless you want to go on a bug hunt!
magic db 0x00
; This fixes what the magic does, and makes it work
mov si, TEXT_startText

mov si, TEXT_startText
call print_string_16

load_sector_2:
    mov  al, 0x01           ; load 1 sector
    mov  bx, 0x7E00         ; destination
    mov  cx, 0x0002         ; cylinder 0, sector 2
    mov  dl, [BootDrive]    ; boot drive
    xor  dh, dh             ; head 0
    
    call read_sectors_16
    ; If carry is set, we either couldn't reset the disk system, or exceeded our max attempts.
    jnc  .success

    mov si, TEXT_loadFailed
    call print_string_16

    ; Jump to halt, which just prevents further code execution
    jmp halt
.success:
    mov si, TEXT_kernalStart
    call print_string_16
    ; Jump to the kernal start, and continue there.
    jmp 0x7E00

%include "halt.asm"
%include "read_sectors_16.asm"
%include "print_string_16.asm"

TEXT_loadFailed  db 'Loading sector failed!', 0x0D, 0xA, 0
TEXT_startText   db 'Basic OS Bootloader - Started', 0x0D, 0xA, 0
TEXT_kernalStart db 'Kernal loaded! Handing off control...', 0x0D, 0xA, 0

BootDrive db 0x80           ; The drive we boot from, and read from.

times 510-($-$$) db 0	    ; Pad remainder of boot sector with 0s
dw 0xAA55		            ; The standard PC boot signature