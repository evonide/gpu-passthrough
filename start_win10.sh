#!/bin/bash
# Include basic VM settings.
#--------------------------
my_dir="$(dirname "$0")"
. $my_dir/general_vm_settings.sh

echo "[~] Loading the VM..."
# Define custom VM settings.
#--------------------------
# QEMU name and PID.
OPTS="$OPTS -name Windows10_VGA"
OPTS="$OPTS -pidfile windows10_vga.pid"
# Passthrough USB devices.
OPTS="$OPTS -usb"
# Mouse
OPTS="$OPTS -usbdevice host:046d:c051"
# Keyboard
OPTS="$OPTS -usbdevice host:046d:c316"
# Supply OVMF vars.
OPTS="$OPTS -drive if=pflash,format=raw,file=/home/qemu_vga/vm/windows/OVMF_VARS-pure-efi.fd"
# System drive
OPTS="$OPTS -hda /home/qemu_vga/vm/windows/Windows10.qcow2"
# Game drive
OPTS="$OPTS -hdb /home/qemu_vga/vm/hdd/games_ssd.qcow2"
# CD settings-
#OPTS="$OPTS -cdrom /home/qemu_vga/vm/windows_10_professional.iso"
# Shared folders (they can be accessed by \\10.0.2.4\qemu)...
OPTS="$OPTS -smb /home/qemu_vga/vm/shared_files/"
# Use an emulated video device (use none for disabled).
OPTS="$OPTS -vga qxl"
#OPTS="$OPTS -vga none"
#OPTS="$OPTS -nographic"
# Redirect QEMU's console input and output.
OPTS="$OPTS -monitor stdio"

# Start our vm.
sudo -Hu qemu_vga bash -c "$VM_SOUND taskset -c 0-7 qemu-system-x86_64 $OPTS"
