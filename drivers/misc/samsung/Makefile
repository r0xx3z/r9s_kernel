# SPDX-License-Identifier: GPL-2.0
#
# Makefile for samsung devices that really don't fit anywhere else.
#

obj-$(CONFIG_EXYNOS_PASR)	   += exynos_pasr.o

# Sec sensor
obj-$(CONFIG_SEC_SENSOR)		 += sensors_lego/

# SPU signature verify
obj-$(CONFIG_SPU_VERIFY)     += spu-sign-verify.o

# Dev-Ril-Bridge driver
obj-$(CONFIG_DEV_RIL_BRIDGE) += dev_ril_bridge.o

# vision drivers
obj-$(CONFIG_VISION_SUPPORT) += vision/

# Samsung STI
obj-$(CONFIG_SEC_STI)		     += abc/

# Mobicore driver
obj-$(CONFIG_TRUSTONIC_TEE)  += gud-exynos2100/MobiCoreDriver/

# Samsung Trustzone Teegris UI
obj-$(CONFIG_SAMSUNG_TUI)	   += tui/

# TEEGRIS kernel driver
ccflags-y += -I$(srctree)/drivers/misc/samsung/tzdev/include
obj-y += tzdev/

# BTS
obj-y  += bts/

# MUIC common
obj-$(CONFIG_USE_MUIC)	     += muic/
