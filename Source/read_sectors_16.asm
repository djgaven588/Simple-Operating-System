; read_sectors_16
;
; Reads sectors from disk into memory using BIOS services
;
; input:    dl      = drive
;           ch      = cylinder[7:0]
;           cl[7:6] = cylinder[9:8]
;           dh      = head
;           cl[5:0] = sector (1-63)
;           es:bx  -> destination
;           al      = number of sectors
;
; output:   cf (0 = success, 1 = failure)
read_sectors_16:
    pusha
    mov si, 0x02    ; maximum attempts - 1
.top:
    mov ah, 0x02    ; read sectors into memory (int 0x13, ah = 0x02)
    int 0x13
    jnc .end        ; exit if read succeeded
    dec si          ; decrement remaining attempts
    jc  .end        ; exit if maximum attempts exceeded
    xor ah, ah      ; reset disk system (int 0x13, ah = 0x00)
    int 0x13
    jnc .top        ; retry if reset succeeded, otherwise exit
.end:
    popa
    retn