#### How to expand disk space on CentOS 7 using LVM
#### This assumes that you already added free space or have another
#### Drive to format
# Show the space that you have available
fdisk -l

# Use Fdisk to create a new partition, the "sda" partition
# Will vary depending on what drive you are using
fdisk /dev/sda
# Show the help menu in case you want it
m

# new
n

# Chose primary partition
p

# Choose the number partion you want
############### Press Enter for default number ######
# Chose the starting point in memory
############### Press Enter for default number ######
# Chose the ending point in memeory
############### Press Enter for default number ######

# Set the type of partition
t
############### Press Enter for default number ######
# list possible hex codes to use
L
# Use the Linux LVM
8e

# Save changes to fdisk
w

## You may get a warning telling you to reboot
# If you see this, then reboot
reboot

####### Partioning is done ######
# Turn the partion into a physical volume
# Again the drive will probably be different
pvcreate /dev/sda4

## Display the volume group names
vgdisplay

# Extend the volume group with our new partition
vgextend <VG name> /dev/sda4

# Confirm that the free space is now available
# You should see that the 'Free Space' field has some numbers now
vgdisplay

# Display the logical volumes
lvdisplay

# List all physical volumes and their volume groups they exist in
pvscan

# Extend by a specific amount of spcace
lvextend -L+300G /dev/<VOLUME GROUP (i.e. centos)>/<LOGICAL VOLUME (i.e root)>

# Confirm that our volume group was extended
vgdisplay

# Resize the actual filesystem that runs on top of the volume groups
# If you are using the xfs filesystem (Default in CentOS 7)
xfs_growfs /dev/cl/root
## If you are using another filesystem, look up the command
