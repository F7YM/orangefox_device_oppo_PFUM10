#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oppo/PFUM10

# Inherit from TWRP/OrangeFox common product configuration
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit device-specific configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Device identifier
PRODUCT_DEVICE := PFUM10
PRODUCT_NAME := twrp_PFUM10
PRODUCT_BRAND := OPPO
PRODUCT_MODEL := OPPO A96 5G
PRODUCT_MANUFACTURER := OPPO

PRODUCT_GMS_CLIENTID_BASE := android-oppo
