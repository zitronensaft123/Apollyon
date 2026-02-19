; my own bootloader! (★^O^★)

org 0x7C00                          ; BIOS loads us at memory address 0x7C00
[bits 16]                           ; assemble in 16bit

start:

    cli                             ; disable interrputs
    
    mov ax, 0                       ; clear ax register
    mov ss, ax                      ; set stack segment to 0
    mov sp, 0x7C00                  ; set stack pointer to 0x7C00

    ; print all the register to the screen + other cool stuff :D
    call print_info

    loop:
        jmp loop                    ; infinite loop


    ; enter protected mode
    lgdt [gdt_descriptor]           ; load GDT

    mov eax, cr0                    ; move the value of CR0 (control register 0) into eax
    or eax, 1                       ; set bit 0 of EAX to 1 (bitwise OR)
    mov cr0, eax                    ; enable protected mode

    jmp 0x08:protected_mode_start   ; far jump  

; print infotext to screen
print_info:
    call print_newline
    mov si, introduction
    call print_string               
    call print_newline
    call print_newline
    mov si, realmode
    call print_string 
    call print_newline
    mov si, content
    call print_string 
    call print_newline
    call print_registers
    ret

; print all registers to screen (i have no idea if theres a better way for this)
print_registers:
    ; general purpose registers
    mov si, max             
    call print_string       ; this ones probably 0E00 because i put 0E into ah
    call print_register
    call print_newline
    mov si, mbx             
    call print_string 
    mov ax, bx              ; random or 0000
    call print_register
    call print_newline
    mov si, mcx
    call print_string 
    mov ax, cx              ; random or 0000
    call print_register
    call print_newline
    mov si, mdx
    call print_string 
    mov ax, dx              ; random or 0000
    call print_register
    call print_newline
    mov si, msp
    call print_string 
    mov ax, sp              ; stack pointer starts at 7C00, push and it decreases, so something less than that
    call print_register
    call print_newline
    mov si, mbp
    call print_string 
    mov ax, bp              ; random or 0000
    call print_register
    call print_newline
    mov si, msi
    call print_string 
    mov ax, si              ; stringpointer, points to the current string im printing that is stored above 7C00, so a bit more than that
    call print_register
    call print_newline
    mov si, mdi
    call print_string 
    mov ax, di              ; random or 0000
    call print_register
    call print_newline

    ; Segment Registers:

    ret

; print register to screen
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

; print a newline to screen
print_newline:
    mov al, 0x0D    ; return char   
    mov ah, 0x0E    ; no idea
    int 0x10

    mov al, 0x0A    ; newline char
    int 0x10
    ret

; print a string to screen
print_string:
    lodsb                           ; load next byte from [SI] string into AL, increment SI
    cmp al, 0                       ; compare AL with 0 to check if null terminator
    je .done                        ; jump if equal (reached null terminator)
    int 0x10                        ; call BIOS interrput 10h
    jmp print_string                 ; to next char

.done:
    ret                             ; return to caller

; all my cool message strings 
introduction db "=== Welcome to ApollyonOS! ===", 0  
realmode db "CPU is currently in Real mode!", 0  
content db "Real mode register content:", 0  
max db "AX: ", 0  
mbx db "BX: ", 0  
mcx db "CX: ", 0  
mdx db "DX: ", 0  
msp db "SP: ", 0  
mbp db "BP: ", 0  
msi db "SI: ", 0  
mdi db "DI: ", 0  

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
