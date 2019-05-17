print_string_16:
    pusha
    mov  ah, 0x0E    ; teletype output (int 0x10, ah = 0x0E)
    mov  bx, 0x0007  ; bh = page number (0), bl = foreground colour (light grey)
.print_char:
    lodsb            ; al = [ds:si]++
    test al, al
    jz   .end        ; exit if null-terminator found
    int  0x10        ; print character
    jmp  .print_char ; repeat for next character
.end:
    popa
    retn