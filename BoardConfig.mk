#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oppo/PFUM10

# Architecture (Qualcomm SM6375 / holi - Kryo 660 ARMv8.2-A)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

# Bootloader
TARGET_NO_BOOTLOADER := false
TARGET_USES_UEFI := true
TARGET_USES_REMOTEPROC := true

# Boot / Kernel (Recovery-in-Boot, Boot Header v3, gzip ramdisk)
BOARD_USES_RECOVERY_AS_BOOT := true
# PFUM10 has no bootloader fastboot; do NOT inject twrpfastboot=1 into boot.img
# cmdline or first_stage_init ForceNormalBoot() will always return false and
# trap the device in recovery.
TW_NO_FASTBOOT_BOOT := true
BOARD_BOOT_HEADER_VERSION := 3
BOARD_KERNEL_PAGESIZE := 4096
# Match stock boot_a header version/patchlevel so ABL -> Keymaster 4.1 never
# sees an unintended OS version / patchlevel bump on normal boot.
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION) --os_version 12.0.0 --os_patch_level 2023-09
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image

# Partition sizes (verified via blockdev --getsize64 & lpdump on PFUM10)
BOARD_BOOTIMAGE_PARTITION_SIZE := 167772160
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 167772160
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)

# Dynamic / Logical Partitions
BOARD_SUPER_PARTITION_SIZE := 11190403072
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 11186208768
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    product \
    vendor \
    odm \
    my_product \
    my_engineering \
    my_company \
    my_carrier \
    my_region \
    my_heytap \
    my_stock \
    my_preload \
    my_bigball \
    my_manifest

# Filesystems
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := odm
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_USES_METADATA_PARTITION := true
TARGET_USES_MKE2FS := true

# AVB (disabled on device vbmeta_a)
BOARD_AVB_ENABLE := false

# Build rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_USES_BUILD_HOST_SHARED_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_STATIC_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_EXECUTABLE := true
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

# Recovery
TARGET_OTA_ASSERT_DEVICE := PFUM10,OP5267,holi
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Libraries needed by stock QTI boot@1.1 HAL and debug tools
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.boot@1.0 \
    android.hardware.boot@1.1 \
    libion \
    libdebuggerd_client \
    debuggerd \
    strace

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.boot@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.boot@1.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdebuggerd_client.so

RECOVERY_BINARY_SOURCE_FILES += \
    $(TARGET_OUT_EXECUTABLES)/debuggerd \
    $(TARGET_OUT_EXECUTABLES)/strace

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# TWRP Display / Hardware / Features
TW_THEME := portrait_hdpi
TW_FRAMERATE := 60
TW_MAX_BRIGHTNESS := 4095
TW_DEFAULT_BRIGHTNESS := 1024
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_CUSTOM_CPU_TEMP_PATH := "/sys/devices/virtual/thermal/thermal_zone32/temp"
TW_USE_LEGACY_BATTERY_SERVICES := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_NO_EXFAT_FUSE := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_RESETPROP := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_NO_SCREEN_BLANK := true
TW_OVERRIDE_SYSTEM_PROPS := \
    "ro.build.fingerprint=ro.vendor.build.fingerprint;ro.build.version.incremental"

# Phase 1: Focus on clean boot & core recovery features before FBE wrappedkey_v0 port
TW_INCLUDE_CRYPTO := false

# Load ADSP/audio base dlkm modules from recovery ramdisk (helps battery gauge on SM6375)
TW_LOAD_VENDOR_MODULES := "q6_pdr_dlkm.ko q6_notifier_dlkm.ko snd_event_dlkm.ko apr_dlkm.ko adsp_loader_dlkm.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true

# OrangeFox Recovery Configuration
OF_MAINTAINER := F7YM
FOX_TARGET_DEVICES := PFUM10,OP5267,holi
OF_SCREEN_H := 2400
OF_STATUS_H := 100
OF_STATUS_INDENT_LEFT := 120
OF_STATUS_INDENT_RIGHT := 48
OF_CLOCK_POS := 1
OF_ALLOW_DISABLE_NAVBAR := 0
OF_USE_GREEN_LED := 0
OF_FLASHLIGHT_ENABLE := 0
OF_ENABLE_LPTOOLS := 1
OF_ENABLE_WLAN := 0
OF_DEFAULT_TIMEZONE := CST-8
OF_QUICK_BACKUP_LIST := /boot;/vendor_boot;/dtbo;

# A/B & Virtual A/B (Recovery-in-Boot)
FOX_AB_DEVICE := 1
FOX_VIRTUAL_AB_DEVICE := 1
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 0
FOX_RECOVERY_BOOT_PARTITION := /dev/block/bootdevice/by-name/boot
FOX_RECOVERY_SYSTEM_PARTITION := /dev/block/mapper/system
FOX_RECOVERY_VENDOR_PARTITION := /dev/block/mapper/vendor

# Shell & Tools
FOX_USE_BASH_SHELL := 1
FOX_ASH_IS_BASH := 1
FOX_USE_NANO_EDITOR := 1
FOX_USE_TAR_BINARY := 1
FOX_USE_SED_BINARY := 1
FOX_USE_XZ_UTILS := 1
FOX_USE_ZSTD_BINARY := 1
FOX_DELETE_AROMAFM := 1
