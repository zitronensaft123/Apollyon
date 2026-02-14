org 0x7C00                          ; BIOS loads us at memory address 0x7C00

start:
    cli                             ; disable interrputs

    mov ax, 0                       ; clear ax register
    mov ss, ax                      ; set stack segment to 0
    mov sp, 0x7C00                  ; set stack pointer to 0x7C00

    mov si, msg
    call print                      ; call the print func

    hang:
        jmp hang                    ; infinite loop

print:
    mov ah, 0X0E                    ; set BIOS function to 0x0E (print char in TTY)

.next:
    lodsb                           ; load next byte from [SI] string into AL, increment SI
    cmp al, 0                       ; compare AL with 0 to check if null terminator
    je .done                        ; jump if equal (reached null terminator)
    int 0x10                        ; call BIOS interrput 10h
    jmp .next                       ; to next char

.done:
    ret                             ; return to caller

msg db "Hello from bootloader!", 0  ; message

times 510-($-$$) db 0               ; pad to 510 bytes  
dw 0xAA55                           ; boot signature 