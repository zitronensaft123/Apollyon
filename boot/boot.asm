org 0x7C00                          ; BIOS loads us at memory address 0x7C00
[bits 16]                           ; assemble in 16bit

start:

    mov ax, 0                       ; clear ax register
    mov ss, ax                      ; set stack segment to 0
    mov sp, 0x7C00                  ; set stack pointer to 0x7C00

    mov si, msg
    call print                      ; call the print func

    cli                             ; disable interrputs

    lgdt [gdt_descriptor]           ; load GDT

    mov eax, cr0                    ; move the value of CR0 (control register 0) into eax
    or eax, 1                       ; set bit 0 of EAX to 1 (bitwise OR)
    mov cr0, eax                    ; enable protected mode

    jmp 0x08:protected_mode_start   ; far jump  

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


[bits 32]                           ; assemble in 32 bit

protected_mode_start:
    mov ax, 0x10                    ; move 0x10 into AX
    mov ds, ax                      ; set ds to the data segment selector
    mov ss, ax                      ; set ss to the data segment selector
    mov esp, 0x90000                ; move the stackpointer away from bootloader code to 0x90000 in memory

    jmp $

gdt:
    dq 0x0000000000000000           ; null descriptor

    dq 0x00CF9A000000FFFF           ; code segment

    dq 0x00CF92000000FFFF           ; data segment

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1            ; size
    dd gdt                          ; address

times 510-($-$$) db 0               ; pad to 510 bytes  
dw 0xAA55                           ; boot signature 
