#!/bin/bash 

if [ -a /usr/bin/vfio-pci-override.sh ]
	then
		rm /usr/bin/vfio-pci-override.sh
fi

if [ -a /etc/initcpio/install/vfio ]
	then
		rm /etc/initcpio/install/vfio
fi

if [ -a rm /etc/initcpio/hooks/vfio ]
	then
		rm rm /etc/initcpio/hooks/vfio
fi

if [ -a /etc/modprobe.d/vfio.conf ]
	then
		rm /etc/modprobe.d/vfio.conf
fi

if [ -a Backup/grub ]
	then
		rm /etc/default/grub
		cp Backup/grub /etc/default/
fi

if [ -a Backup/mkinitcpio.conf ]
	then
		rm /etc/mkinitcpio.conf
		cp Backup/mkinitcpio.conf /etc/
fi

mkinitcpio -P

update-grub

