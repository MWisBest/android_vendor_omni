PRODUCT_BRAND ?= omni

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.fml.superuser

## Boot animation
# With FML, use a smaller (file-size) boot animation, and a properly sized one as well.
ifeq ($(ROM_BUILDTYPE),FML)

TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

bootanimation_sizes := $(subst .zip,, $(shell ls vendor/omni/prebuilt/bootanimation/fml))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bootanimation/fml/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip

else
# Omni stock
ifneq ($(USE_LOWFPS_BOOTANI),true)
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bootanimation/bootanimation.zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bootanimation/lowfps-bootanimation.zip:system/media/bootanimation.zip
endif
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# general properties
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=true

# enable ADB authentication if not on eng build
ifneq ($(TARGET_BUILD_VARIANT),eng)
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/omni/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/omni/prebuilt/bin/50-hosts.sh:system/addon.d/50-hosts.sh \
    vendor/omni/prebuilt/bin/blacklist:system/addon.d/blacklist

# init.d support
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/omni/prebuilt/bin/sysinit:system/bin/sysinit

# FML init.d script
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/init.d/00fml:system/etc/init.d/00fml

# Gesture Typing Lib for LatinIME
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/lib/libjni_unbundled_latinimegoogle.so:system/lib/libjni_unbundled_latinimegoogle.so

# userinit support
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init script file with omni extras
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/init.local.rc:root/init.omni.rc

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

ifneq ($(TARGET_BUILD_VARIANT),user)

# Superuser
PRODUCT_PACKAGES += \
    Superuser \
    su

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1

else

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

endif

# Dashclock
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/app/DashClock.apk:system/app/DashClock.apk

# Additional packages
-include vendor/omni/config/packages.mk

# Versioning
-include vendor/omni/config/version.mk

# Add our overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/omni/overlay/common
