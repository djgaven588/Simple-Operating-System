; The bootloader
; This loads the kernal, which handles everything from here
org 0x7C00
BITS 16                     ; Tell the compiler we are working in 16-bit mode

BootDrv db 0x80

cli                         ; disable interrupts to update ss:sp atomically (AFAICT, only required for <= 286)
xor ax, ax
mov ss, ax
mov sp, 0x7C00
sti

jmp 0x0000:start_16

start_16:
    ; initialise essential segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

mov si, text_string
call print_string_16

text_string db 'Testing!', 0

load_sector_2:
    mov  al, 0x01           ; load 1 sector
    mov  bx, 0x7E00         ; destination (might as well load it right after your bootloader)
    mov  cx, 0x0002         ; cylinder 0, sector 2
    mov  dl, [BootDrv]      ; boot drive
    xor  dh, dh             ; head 0
    call read_sectors_16
    jnc  .success           ; if carry flag is set, either the disk system wouldn't reset, or we exceeded our maximum attempts and the disk is probably shagged
    mov  si, read_failure_str
    call print_string_16
    jmp halt                ; jump to a hang routine to prevent further execution
.success:
    jmp 0x7E00

read_failure_str db 'Boot disk read failure!', 13, 10, 0

%include "halt.asm"
%include "read_sectors_16.asm"
%include "print_string_16.asm"

times 510-($-$$) db 0	    ; Pad remainder of boot sector with 0s
dw 0xAA55		            ; The standard PC boot signature