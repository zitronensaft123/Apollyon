org 0x7C00                          ; BIOS loads us at memory address 0x7C00
[bits 16]                           ; assemble in 16bit

start:

    cli                             ; disable interrputs
    
    mov ax, 0                       ; clear ax register
    mov ss, ax                      ; set stack segment to 0
    mov sp, 0x7C00                  ; set stack pointer to 0x7C00

    ;lgdt [gdt_descriptor]           ; load GDT

    ;mov eax, cr0                    ; move the value of CR0 (control register 0) into eax
    ;or eax, 1                       ; set bit 0 of EAX to 1 (bitwise OR)
    ;mov cr0, eax                    ; enable protected mode

    ;jmp 0x08:protected_mode_start   ; far jump  

    mov ax, 0xBEEF
    call print_register
    
    loop:
        jmp loop                    ; infinite loop


print:
    mov ah, 0X0E                    ; set BIOS function to 0x0E (print char in TTY)

; print registers to screen
print_register:
    ; save values
    push ax
    push bx
    push cx
    push dx

    mov bx, ax          ; copy
    mov cx, 12          ; starting shift value

    ; extract and convert loop
    print_loop:

        mov dx, bx      ; copy
        shr dx, cl      ; shr: shift right by current value in cl
        and dx, 0x000F  ; isolate value

        mov al, dl      ; mov value to al

        ; convert to ASCII
        cmp al, 9
        jbe digit1
        add al, 0x37
        jmp print_char

    digit1:
        add al, 0x30

    ; print, pop and loop
    print_char:

        mov ah, 0x0E
        int 0x10

        sub cx, 4           ; change shift ammount
        jns print_loop      ; loop till cl < 0
        
        ; restore (pop) values
        pop dx
        pop cx
        pop bx
        pop ax
        ret



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
