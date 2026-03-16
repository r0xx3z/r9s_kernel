# SPDX-License-Identifier: GPL-2.0
dtbo-y += r9s_eur_openx_w01_r18.dtbo
dtbo-y += r9s_eur_openx_w01_r17.dtbo
dtbo-y += r9s_eur_openx_w01_r00.dtbo

targets += dtbs

DTB_LIST  := $(dtb-y) $(dtbo-y)
always    := $(DTB_LIST)

dtbs: $(addprefix $(obj)/, $(DTB_LIST))

clean-files := *.dtb*
