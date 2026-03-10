I put some stuff here thats usefull while making this so i dont have to search it up every time <br>

this list is from the osDev Wiki (https://wiki.osdev.org/BIOS)

INT 0x10
AH = 0x0 	Set video mode
AH = 0x1 	Set up the cursor
AH = 0x2 	Set cursor position
AH = 0x3 	Get cursor position
AH = 0xE 	Display character
AH = 0xF 	Get current video page and mode
AH = 0x12 	Detect EGA/VGA
AH = 0x13 	Display string
AX = 0x1110 	Set 8x8 font
AX = 0x1130 	Get 8x8 font
AX = 0x1200 	Alternate print screen
AX = 0x1201 	Turn off cursor emulation
AX = 0x4F00 	VESA get video information
AX = 0x4F01 	VESA get mode information call
AX = 0x4F02 	Select VESA video modes
AX = 0x4F0A 	VESA 2.0 protected mode interface

INT 0x13
AH = 0x0 	Reset floppy/hard disk
AH = 0x2 	Read floppy/hard disk in CHS mode
AH = 0x3 	Write floppy/hard disk in CHS mode
AH = 0x15 	Detect second disk
AH = 0x41 	Test presence of the BIOS Enhanced Disk Drive Services (EDD)
AH = 0x42 	Read to disk in LBA mode
AH = 0x43 	Write from disk in LBA mode

INT 0x14
AH = 0x0 	Initialize serial port
AH = 0x1 	Write byte to serial port
AH = 0x2 	Read byte from serial port
AH = 0x3 	Get serial port status

INT 0x15
AH = 0x86 	Delay for a microsecond interval
AH = 0x87 	Copy data to extended memory
AH = 0xC0 	Detect MCA bus
AX = 0x2400 	Disable A20 gate
AX = 0x2401 	Enable A20 gate
AX = 0x2402 	Get A20 gate status
AX = 0x0530 	Detect APM BIOS
AX = 0x5300 	APM detect
AX = 0x5303 	APM connect using 32 bit
AX = 0x5304 	APM disconnect
EAX = 0xE820 	Get complete memory map
AX = 0xE801 	Get contiguous memory size
AX = 0xE881 	Get contiguous memory size
AH = 0x88 	Get contiguous memory size
AH = 0x89 	Switch to protected mode

INT 0x16
AH = 0x0 	Read keyboard scancode and character (blocking)
AH = 0x1 	Read keyboard scancode and character (non-blocking)
AH = 0x2 	Get modifier keys status
AH = 0x3 	Set keyboard repeat rate

INT 0x1A
AX = 0xB120 	Find PCI device
AX = 0xB103 	Find PCI class code
AX = 0xB106 	PCI bus operations
AX = 0xB108 	PCI read configuration byte
AX = 0xB109 	PCI read configuration word
AX = 0xB108 	PCI read configuration dword 


