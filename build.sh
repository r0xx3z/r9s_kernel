#!/bin/bash
#r9s
#By Ll0rens

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

echo -e "${red}===================="
echo " By Mirandas Kernel"
echo -e "====================${nocol}\n"
sleep 1

# Clone AnyKernel3 only if it does not exist
if [ ! -d "AnyKernel3_r9s" ]; then
    echo "Cloning AnyKernel3 for R9S..."
    git clone -q https://github.com/r0xx3z/AnyKernel3_r9s
else
    echo "AnyKernel3_r9s directory already exists. Skipping clone."
fi

# Change Configs
ANYKERNEL3_r9s_DIR="$PWD/AnyKernel3_r9s"
FINAL_KERNEL_ZIP="Miranda_Kernel-$(date '+%Y%m%d').zip"
KERNEL_DEFCONFIG="xxxxxx"

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

############################
export ARCH=arm64

export PATH="$HOME/android-clang/clang-r522817/bin:$PATH"

export LLVM=1
export LLVM_IAS=1

export KBUILD_BUILD_HOST=Archlinux
export KBUILD_BUILD_USER=Miranda_Kernel
############################

echo -e "${yellow}**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****${nocol}\n"

echo -e "${blue}************************************"
echo "          BUILDING KERNEL          "
echo -e "************************************${nocol}"

# Guardamos el output en el log usando tee
make $KERNEL_DEFCONFIG O=out 2>&1 | tee $LOG_FILE
make -j$(nproc --all) O=out 2>&1 | tee -a $LOG_FILE

# Check to stop the script if the kernel did not compile
if [ ! -f "$PWD/out/arch/arm64/boot/Image" ]; then
    echo -e "\n${red}**** ERROR: Kernel compilation failed! Image file not found. ****${nocol}"
    exit 1
fi

# Initialization of AnyKernel
echo -e "\n**** Verify Image ****"
ls "$PWD/out/arch/arm64/boot/Image"

echo -e "\n**** Verifying AnyKernel3 Directory ****"
ls "$ANYKERNEL3_r9s_DIR"

echo -e "\n**** Removing leftovers ****"
rm -f "$ANYKERNEL3_r9s_DIR/Image"
rm -f "$ANYKERNEL3_r9s_DIR/$FINAL_KERNEL_ZIP"

echo -e "\n**** Copying Image ****"
cp "$PWD/out/arch/arm64/boot/Image" "$ANYKERNEL3_r9s_DIR/"

echo -e "\n**** Make kernel.zip! ****"
cd "$ANYKERNEL3_r9s_DIR/"
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
