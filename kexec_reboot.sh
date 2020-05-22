#!/bin/bash
# reboot faster after kernel upgrade
# dep: kexec-tools
set -eu

kexec_reboot() {
  current_kernel=$(uname -r)
  new_kernel=$(rpm -qa kernel | tail -n 1)
  new_kernel=${new_kernel#kernel-}
  
  if [[ $current_kernel != "$new_kernel" ]]; then 
    kexec -l /boot/vmlinuz-${new_kernel} \
      --initrd=/boot/initramfs-${new_kernel}.img \
      --reuse-cmdline
    sync
    ( nohup sleep 2 && kexec -e & )
    return
  else
    printf "No new kernel\n"
  fi
}

if [[ -x /usr/sbin/kexec ]]; then
  kexec_reboot
else
  echo reboot
fi
exit 0
