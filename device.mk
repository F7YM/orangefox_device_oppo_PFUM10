#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oppo/PFUM10

# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Installs GSI AVB public keys into first_stage_ramdisk/avb/
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Platform
TARGET_BOARD_PLATFORM := holi
TARGET_BOOTLOADER_BOARD_NAME := holi
QCOM_BOARD_PLATFORMS += holi

# API / VNDK
BOARD_SHIPPING_API_LEVEL := 30
PRODUCT_SHIPPING_API_LEVEL := 30
PRODUCT_TARGET_VNDK_VERSION := 30

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# A/B support (Recovery-in-Boot, no dedicated recovery partition)
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    system \
    system_ext \
    product \
    vendor \
    odm

# Update engine & sideload
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_engine_sideload \
    update_verifier

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.1-impl-mock

# f2fs & checkpoint utilities
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs \
    checkpoint_gc

# Recovery-only prebuilt kernel build: skip OTA kernel VINTF check
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Support compiling recovery without full MSM kernel headers
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

# Soong / Make compatibility
BUILD_BROKEN_DUP_RULES := true
RELAX_USES_LIBRARY_CHECK := true

PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

# Fuse passthrough
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.fuse.passthrough.enable=true

# Overlay recovery root files
TARGET_RECOVERY_DEVICE_DIRS += $(DEVICE_PATH)/twrp
