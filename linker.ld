/* AI made this aswell, no idea what language this even is*/

ENTRY(_start)                /* The name of the label in kernel_entry.asm */
OUTPUT_FORMAT("binary")      /* raw binary */

SECTIONS
{
    . = 0x1000;              /* Start at memory address 0x1000 */

    .text : {
        boot/kernel_entry.o  /* force the bridge to be at the very front */
        *(.text)             /* Then all other code */
    }

    .data : { *(.data) }     /* all initialized variables */
    .bss  : { *(.bss) }      /* all uninitialized variables */
}