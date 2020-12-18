#!/sbin/sh

echo "Mounting system"
mkdir /system_root
mount -t ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system_root -o rw,discard

board_id="";
for e in $(cat /proc/cmdline);
do
    tmp=$(echo $e | grep "board_id" > /dev/null);
    if [ "0" == "$?" ]; then
        board_id=$(echo $e |cut -d":" -f0 |cut -d"=" -f2);
    fi
done

device="A6020a40"; # a40 SD415 is the default variant
soc="8929";
case "$board_id" in
    "S82918B1"|"S82918H1")
        device="A6020a46" # a40 SD616 uses the same blobs from a46
        soc="8939"
    ;;
    "S82918E1")
        device="A6020a41"
    ;;
    "S82918F1")
        device="A6020l36"
        soc="8939"
    ;;
    "S82918G1")
        device="A6020l37"
        soc="8939"
    ;;
esac

# Move variant-specific blobs
mv /system_root/etc/firmware/variant/$device/* /system_root/etc/firmware/
rm -rf /system_root/etc/firmware/variant

# Copy media configs
mv /system_root/vendor/etc/media_codecs_$soc.xml /system_root/vendor/etc/media_codecs.xml
mv /system_root/vendor/etc/media_codecs_performance_$soc.xml /system_root/vendor/etc/media_codecs_performance.xml

umount /system_root
