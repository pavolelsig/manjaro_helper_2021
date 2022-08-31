# Sources:
# https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs
# https://forum.manjaro.org/t/virt-manager-fails-to-detect-ovmf-uefi-firmware/110072

# Backup files

mkdir Backup
chmod +x uninstall.sh

cp /etc/default/grub Backup
cp /etc/mkinitcpio.conf Backup
cp /etc/default/grub new_grub
###
#Detecting CPU
CPU=$(lscpu | grep GenuineIntel | rev | cut -d ' ' -f 1 | rev )

INTEL="0"

if [ "$CPU" = "GenuineIntel" ]
	then
	INTEL="1"
fi

#Building string Intel or AMD iommu=on
if [ $INTEL = 1 ]
	then
	IOMMU="intel_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1"
	echo "Set Intel IOMMU On"
	else
	IOMMU="amd_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1"
	echo "Set AMD IOMMU On"
fi

#Putting together new grub string
OLD_OPTIONS=`cat new_grub | grep GRUB_CMDLINE_LINUX_DEFAULT | cut -d '"' -f 1,2`

NEW_OPTIONS="$OLD_OPTIONS $IOMMU\""
echo $NEW_OPTIONS

#Rebuilding grub 
sed -i -e "s|^GRUB_CMDLINE_LINUX_DEFAULT.*|${NEW_OPTIONS}|" new_grub

#User verification of new grub and prompt to manually edit it
echo 
echo "Grub was modified to look like this: "
echo `cat new_grub | grep "GRUB_CMDLINE_LINUX_DEFAULT"`
echo 
echo "Do you want to edit it? y/n"
read YN

if [ $YN = y ]
then
nano new_grub
fi

cp new_grub /etc/default/grub

# Install required packages

pacman -S vim qemu virt-manager ovmf dnsmasq ebtables #iptables

#Checking for TPM

ls /dev/tpm* 2>/dev/null 1>/dev/null

if  [ $? = 0 ]
then
	echo "TPM found. It is not necessary to install a TPM emulator."
	
else
	echo " "
	echo " "
	echo "TPM is required for running Windows 11 VMs!"
	echo "Do you want to install a TPM emulator 'swtpm'? y/n  "
	read TPM
		if [ $TPM = y ]
		then
			pacman -S swtpm
			
		fi
fi

# Allow libvirt to autostart

systemctl enable libvirtd.service

# Copy necessary files

cp vfio-pci-override.sh /usr/bin/vfio-pci-override.sh
chmod +x /usr/bin/vfio-pci-override.sh
cp vfio-install /etc/initcpio/install/vfio
cp vfio-hooks /etc/initcpio/hooks/vfio
cp vfio.conf /etc/modprobe.d/



# Edit mkinitcpio.conf

MODULES='vfio_pci vfio vfio_iommu_type1 vfio_virqfd'
FILES='/usr/bin/vfio-pci-override.sh'
HOOKS='vfio'

cp /etc/mkinitcpio.conf new_mkinitcpio

sed -i "\|^MODULES=| s|(\(.*\))|(${MODULES} \1)|" new_mkinitcpio
sed -i "\|^MODULES=| s|\"\(.*\)\"|\"${MODULES} \1\"|" new_mkinitcpio

sed -i "\|^FILES=| s|(\(.*\))|(${FILES} \1)|" new_mkinitcpio
sed -i "\|^FILES=| s|\"\(.*\)\"|\"${FILES} \1\"|" new_mkinitcpio

sed -i "\|^HOOKS=| s|base\(.*\) udev|base ${HOOKS}\1 udev|" new_mkinitcpio

#User verification of new mkinitcpio and prompt to manually edit it
echo 
echo "Mkinitcpio was modified. "
echo "Do you want to edit/verify it? y/n"
read YN

if [ $YN = y ]
then
nano new_mkinitcpio
fi


cp new_mkinitcpio /etc/mkinitcpio.conf

mkinitcpio -P
update-grub

