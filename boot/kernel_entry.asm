[bits 32]                   ; assemble in 32bit
global _start               ; export _start so the linker can use it
[extern kernel_main]        ; declare kernel_main 
_start:
    call kernel_main        ; jump to kernel_main
    jmp $                   ; if kernel_main returns, loop