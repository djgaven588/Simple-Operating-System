org 0x7E00
BITS 16

mov si, TEXT_loadSector	    ; Put 'text_string' reference into si register
call print_string_16    ; Call print_string, coming back here after

jmp $			        ; Jump to here, from here. Infinite loop.

TEXT_loadSector db 'This is my first OS, and it works!', 0x0D, 0xA, 0

%include "print_string_16.asm"

times 512-($-$$) db 0	; Pad remainder with 0s, should always be a multiple of 512