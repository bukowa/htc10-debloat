#!/system/bin/sh
# Debloat Script for HTC 10 (Android N/O)
# WARNING: Use with extreme caution. Make a full NANDROID backup first!
# This script requires root access and remounts /system partition.

echo "#####################################################"
echo "# WARNING: This script modifies your system partition."
echo "# Ensure you have a full NANDROID backup before proceeding."
echo "# Incorrect usage can lead to bootloops or system instability."
echo "# You need a custom recovery (like TWRP) to flash this or run via ADB shell with root."
echo "#####################################################"
echo ""

# Confirm before proceeding - using compatible read
echo "Do you understand the risks and want to proceed? (type 'yes' to continue):"
read CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Aborting script."
    exit 1
fi

echo "Mounting /system partition as read-write..."
# It's good practice to try multiple paths for mount if one fails, or assume current path is correct
# For Android, /system is typically mounted directly from root.
mount -o rw,remount /system || { echo "Failed to remount /system. Exiting."; exit 1; }
mount -o rw,remount /preload || { echo "Failed to remount /preload. Exiting."; exit 1; }

APP_REMOVE_LIST=(
    AndroidPay
    CompanionDeviceManager
    CtsShimPrebuilt
    Duo
    EasterEgg
    ExactCalculator
    FaceLock
    HTCSpeakCyberon
    HTC_Connect
    HTMLViewer
    Hangouts
    HtcCompressViewer
    HtcResetNotify
    MyHTC
    News_Republic
    PacProcessor
    PartnerBookmarksProvider
    PrintSpooler
    SmartcardService
    TouchPal_ArabicPack
    TouchPal_ArmenianPack
    TouchPal_BulgarianPack
    TouchPal_CangjiePack
    TouchPal_CatalanPack
    TouchPal_ChtPack
    TouchPal_CroatianPack
    TouchPal_CzechPack
    TouchPal_DanishPack
    TouchPal_DutchPack
    TouchPal_EstonianPack
    TouchPal_FinnishPack
    TouchPal_FrenchPack
    TouchPal_GermanPack
    TouchPal_GreekPack
    TouchPal_HandwritePack
    TouchPal_HebrewPack
    TouchPal_HungarianPack
    TouchPal_IndonesianPack
    TouchPal_ItalianPack
    TouchPal_KazakhPack
    TouchPal_LatvianPack
    TouchPal_LithuanianPack
    TouchPal_MalayanPack
    TouchPal_NorwegianPack
    TouchPal_PersianPack
    TouchPal_PinyinPack
    TouchPal_PortugueseptPack
    TouchPal_RomanianPack
    TouchPal_RussianPack
    TouchPal_SerbianlatinPack
    TouchPal_SimpleCangjiePack
    TouchPal_Skin_DefaultWhite
    TouchPal_SlovakPack
    TouchPal_SlovenianPack
    TouchPal_SpanishPack
    TouchPal_SpanishUSPack
    TouchPal_SwedishPack
    TouchPal_TurkishPack
    TouchPal_UkrainianPack
    WAPPushManager
    WallpaperBackup
    facebook-stub
    messenger-stub
    talkback
    instagram-stub
	YouTube
	Drive
	EditorDocs
	Maps
	Photos
	Music2
	Gmail2
	Videos
)

PRIV_APP_REMOVE_LIST=(
    AdaptiveSound
    AndroidHtcSync
    AntHalService
    AppCloud
    BackupRestoreConfirmation
    CtsShimPrivPrebuilt
    CustomizationSettingsProvider
    CustomizationSetup
    Default_IME_Provider
    DemoFLOPackageInstaller
    DrawingBoard
    EasyAccessService
    Facebook
    FlexNet
    Frisbee
    HMS_PhotoEnhancer2
    HMS_VideoPlayer2
    HTCAdvantage
    HTCZero
    HtcBIDHandler
    HtcContactsDNATransfer
    HtcDLNAMiddleLayer
    HtcEPSLauncher
    HtcIceView
    HtcMobileDataLite
    HtcPowerStripWidget
    HtcRingtoneTrimmer
    HtcSoundRecorder
    HtcWeatherClockWidget
    HomePersonalize
    LocationPicker
    Mail
    MirrorLink_MirrorLinkService
    NeroHTCInstaller
    PitroadEnhancerService
    PNSClient
    SA_AdapterFWUpdateTool
    SMSBackup
    SmithLite
    SoundPicker
    StatementService
    Tag
    Twitter
    UDove
    UIBC
    Weather
    WorldClock
    iCloudTransfer
	TouchPal_SmartSearch
	ContextualWidget
	HtcAccessoryService
	CheckinProvider
	GooglePlusPlugin
	AMapNetworkLocation
	Velvet
)

EXTRA_REMOVE_PATHS=(
    "/system/priv-app/installer"
    "/preload/Boost+.apk"
    "/preload/UAR_Stub.apk"
    "/preload/Flashlight.apk"
    "/preload/Viveport_Inst.apk"
)

echo ""
echo "Removing unwanted applications from /system/app/..."
for app in "${APP_REMOVE_LIST[@]}"; do
    APP_PATH="/system/app/$app"
    if [ -d "$APP_PATH" ]; then
        echo "Removing $APP_PATH..."
        rm -rf "$APP_PATH"
    else
        echo "Warning: $APP_PATH not found, skipping."
    fi
done

echo ""
echo "Removing unwanted applications from /system/priv-app/..."

for app in "${PRIV_APP_REMOVE_LIST[@]}"; do
    PRIV_APP_PATH="/system/priv-app/$app"
    if [ -d "$PRIV_APP_PATH" ]; then
        echo "Removing $PRIV_APP_PATH..."
        rm -rf "$PRIV_APP_PATH"
    else
        echo "Warning: $PRIV_APP_PATH not found, skipping."
    fi
done

echo ""
echo "Removing extras..."

for path in "${EXTRA_REMOVE_PATHS[@]}"; do
    if [ -e "$path" ]; then
        echo "Removing $path..."
        rm -rf "$path"
    else
        echo "Warning: $path not found, skipping."
    fi
done

echo "--> Removing XML configuration files from /preload/..."
# Use a wildcard to delete all of them
if [ -f "/preload/HTC__002.xml" ]; then # Check if any exist before trying
    echo "    Deleting all HTC__*.xml files"
    rm -f /preload/HTC__*.xml
fi

echo ""
echo "Cleaning up residual files (e.g., ODEX/ART files)..."
# This command clears the dalvik-cache, forcing Android to rebuild it
# on next boot, ensuring removed app components are gone.
# Note: You might need to adjust this path based on your Android version,
# but /data/dalvik-cache is common.
rm -rf /data/dalvik-cache/*

echo "Remounting /system partition as read-only..."
mount -o ro,remount /system || { echo "Failed to remount /system as read-only. Please do it manually after reboot."; }

echo ""
echo "Syncing filesystem changes..."
sync

echo "Debloating script complete. It is HIGHLY RECOMMENDED to reboot your device now."
echo "If your device encounters bootloop issues, restore your NANDROID backup."
reboot
