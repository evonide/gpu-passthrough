#!/bin/bash
# Give our QEMU_VGA user XServer access rights.
xhost +SI:localuser:qemu_vga > /dev/null

echo "[~] Loading general VM settings..."
OPTS=""
# Basic CPU settings.
OPTS="$OPTS -cpu host,kvm=off,hv_spinlocks=0x1fff,hv_relaxed,hv_vapic,hv_time,hv_vendor_id=Nvidia43FIX"
OPTS="$OPTS -smp 8,sockets=1,cores=4,threads=2"
OPTS="$OPTS -enable-kvm"
# Assign memory to the vm.
OPTS="$OPTS -m 16000"
OPTS="$OPTS -mem-prealloc"
OPTS="$OPTS -balloon none"
#OPTS="$OPTS -mem-path /dev/hugepages"
# VFIO GPU and GPU sound passthrough.
OPTS="$OPTS -device vfio-pci,host=02:00.0,multifunction=on"
OPTS="$OPTS -device vfio-pci,host=02:00.1"
# Supply OVMF (general UEFI bios, needed for EFI boot support with GPT disks).
OPTS="$OPTS -drive if=pflash,format=raw,readonly,file=/usr/share/edk2.git/ovmf-x64/OVMF_CODE-pure-efi.fd"
# Emulate a sound device.
OPTS="$OPTS -soundhw hda"
#OPTS="$OPTS -soundhw ac97"
# Machine settings.
#OPTS="$OPTS -M q35"
#OPTS="$OPTS -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"
# Synergy port forward
OPTS="$OPTS -redir tcp:24800::24800"
# Load the German keyboard layout again (needed for proper Synergy support).
setxkbmap de nodeadkeys
# Debug OVMF if necessary.
#OPTS="$OPTS -global isa-debugcon.iobase=0x402 -debugcon file:/tmp/qemu_vga.ovmf.log"
# Network settings (haven't used those yet).
#OPTS="$OPTS -netdev tap,vhost=on,ifname=$VM,script=/usr/local/bin/vm_ifup_brlan,id=brlan"
#OPTS="$OPTS -device virtio-net-pci,mac=52:54:00:xx:xx:xx,netdev=brlan"
# Disable all unncecessary ports.
OPTS="$OPTS -serial null"
OPTS="$OPTS -parallel null"
# Select a QEMU sound driver and specify its settings.
VM_SOUND="$VM_SOUND QEMU_AUDIO_DRV=alsa"
VM_SOUND="$VM_SOUND QEMU_AUDIO_DAC_FIXED_FREQ=48000"
VM_SOUND="$VM_SOUND QEMU_ALSA_DAC_BUFFER_SIZE=512"
VM_SOUND="$VM_SOUND QEMU_ALSA_DAC_PERIOD_SIZE=170"
