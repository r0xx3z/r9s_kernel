#!/bin/bash
#r9s

#set -e

# LOGS
LOG_FILE="logs.txt"
BUILD_START=$(date +"%s")

# Colores
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

echo -e "${red}############"
echo " By Roxx_3z"
echo -e "############${nocol}\n"
sleep 1

# Clonar AnyKernel3 solo si no existe
if [ ! -d "AnyKernel3" ]; then
    echo "Cloning AnyKernel3..."
    git clone -q https://github.com/ProtonKernel/AnyKernel3.git
else
    echo "AnyKernel3 directory already exists. Skipping clone."
fi

ANYKERNEL3_DIR="$PWD/AnyKernel3"
FINAL_KERNEL_ZIP="Miranda_Kernel-$(date '+%Y%m%d').zip"
KERNEL_DEFCONFIG="r9s_defconfig"

echo ""
sleep 1
echo "Starting in 3..."
sleep 1
echo "Starting in 2..."
sleep 1
echo "Starting in 1..."
sleep 1
echo ""

# Clean build always
echo -e "${cyan}**** Cleaning ****${nocol}"
mkdir -p out
make O=out clean
echo ""

export ARCH=arm64
export LLVM=1
export LLVM_IAS=1
export PATH="$HOME/android-clang-r522817/bin:$PATH"

echo -e "${yellow}**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****${nocol}\n"

echo -e "${blue}************************************"
echo "          BUILDING KERNEL          "
echo -e "************************************${nocol}"

# Guardamos el output en el log usando tee
make $KERNEL_DEFCONFIG O=out 2>&1 | tee $LOG_FILE
make -j$(nproc --all) O=out 2>&1 | tee -a $LOG_FILE

echo -e "\n**** Verify Image ****"
ls "$PWD/out/arch/arm64/boot/Image"

echo -e "\n**** Verifying AnyKernel3 Directory ****"
ls "$ANYKERNEL3_DIR"

echo -e "\n**** Removing leftovers ****"
rm -f "$ANYKERNEL3_DIR/Image"
rm -f "$ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP"

echo -e "\n**** Copying Image ****"
cp "$PWD/out/arch/arm64/boot/Image" "$ANYKERNEL3_DIR/"

echo -e "\n**** Make kernel.zip! ****"
cd "$ANYKERNEL3_DIR/"
zip -r9 "$FINAL_KERNEL_ZIP" *

echo -e "\n**** MV to BUILDS DIR ****"
BUILDS_DIR="$HOME/BUILDS"
mkdir -p "$BUILDS_DIR"
cp "$FINAL_KERNEL_ZIP" "$BUILDS_DIR/"


cd - > /dev/null

echo ""
sleep 2

# End compilation Dates
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))
echo -e "${yellow}Build completed in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds.${nocol}"
echo "Completed"
