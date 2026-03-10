#  i did not make this file myself i asked AI to do it for me (⊃‿⊂)

# Path Definitions
BOOT_DIR = boot
KERNEL_DIR = kernel

# Output Files
BOOT_BIN = $(BOOT_DIR)/boot.bin
ENTRY_OBJ = $(BOOT_DIR)/kernel_entry.o
KERNEL_OBJ = $(KERNEL_DIR)/kernel.o
KERNEL_BIN = $(KERNEL_DIR)/kernel.bin

# Final Image
IMAGE = os_image.bin

# Build all
all: $(IMAGE)

# Combine Bootloader + Kernel
$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(IMAGE)

# Link the Kernel (Entry + C Code)
$(KERNEL_BIN): $(ENTRY_OBJ) $(KERNEL_OBJ)
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Compile C Code
$(KERNEL_OBJ): $(KERNEL_DIR)/kernel.c
	gcc -m32 -ffreestanding -fno-pic -c $< -o $@

# Assemble Kernel Entry Bridge
$(ENTRY_OBJ): $(BOOT_DIR)/kernel_entry.asm
	nasm $< -f elf32 -o $@

# Assemble Bootloader
$(BOOT_BIN): $(BOOT_DIR)/boot.asm
	nasm $< -f bin -o $@

# Clean up
clean:
	rm -f $(BOOT_DIR)/*.bin $(BOOT_DIR)/*.o $(KERNEL_DIR)/*.bin $(KERNEL_DIR)/*.o $(IMAGE)

# Run in QEMU
run: all
	qemu-system-x86_64 -drive format=raw,file=$(IMAGE) -d int,cpu_reset -no-reboot