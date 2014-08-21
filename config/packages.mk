# Additional packages
PRODUCT_PACKAGES += \
    Basic \
    LatinIME \
    SoundRecorder

# Additional apps
PRODUCT_PACKAGES += \
    Apollo \
    audio_effects.conf \
    DSPManager \
    libcyanogen-dsp \
    MonthCalendarWidget \
    OmniSwitch

PRODUCT_PACKAGES += \
    CellBroadcastReceiver

# Additional tools
PRODUCT_PACKAGES += \
    bash \
    e2fsck \
    fsck.exfat \
    htop \
    lsof \
    mke2fs \
    mkfs.exfat \
    mount.exfat \
    nano \
    openvpn \
    powertop \
    tune2fs \
    vim \
    ntfsfix \
    ntfs-3g \
    mkntfs

# Superuser
PRODUCT_PACKAGES += \
    Superuser \
    su

ifeq ($(DEBUG_EXTRAS),true)
PRODUCT_PACKAGES += \
    memtest \
    memtester
endif

