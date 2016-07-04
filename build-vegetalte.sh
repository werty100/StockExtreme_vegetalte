#
# Custom build script by werty100
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#
# Define variables
u="$USER"
Toolchain="/home/$u/arm-cortex-linux-gnueabi-linaro_4.9.4-2015.06/bin/arm-cortex-linux-gnueabi-"
Kernel_Dir="bq_stock"
KERNEL="/home/$u/$Kernel_Dir/arch/arm/boot/zImage"
Dtbtool="/home/$u/$Kernel_Dir/tools/dtbToolCM"
Mkboot="/home/$u/$Kernel_Dir/tools/mkbootimg_tools/"
#!/bin/bash
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=$Toolchain
export KBUILD_BUILD_USER="werty100"
export KBUILD_BUILD_HOST="BQ"
echo -e "$cyan***********************************************"
echo " Compiling Stock Extreme kernel "
echo -e "***********************************************$nocol"
rm -f arch/arm/boot/dts/*.dtb
rm -f arch/arm/boot/dt.img
rm -f tools/mkbootimg_tools/stock/zImage
rm -f tools/mkbootimg_tools/stock/dt.img
rm -f tools/mkbootimg_tools/stock/newstock.img
rm -f out/boot.img
make clean
echo -e " Initializing defconfig"
make vegetalte_defconfig
echo -e " Building kernel"
make -j8 zImage
make -j8 dtbs
$Dtbtool -2 -o /home/$u/$Kernel_Dir/arch/arm/boot/dt.img -s 2048 -p /home/$u/$Kernel_Dir/scripts/dtc/ /home/$u/$Kernel_Dir/arch/arm/boot/dts/
cp /home/$u/$Kernel_Dir/arch/arm/boot/dt.img /home/$u/$Kernel_Dir/tools/mkbootimg_tools/stock/dt.img
cp /home/$u/$Kernel_Dir/arch/arm/boot/zImage /home/$u/$Kernel_Dir/tools/mkbootimg_tools/stock/zImage
cd $Mkboot 
./mkboot stock newstock.img
cp newstock.img /home/$u/$Kernel_Dir/out/boot.img
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

