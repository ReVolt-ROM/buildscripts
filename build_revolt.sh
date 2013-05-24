#!/bin/bash

ydate=$(date -d '1 day ago' +"%m/%d/%Y")
sdate="$5"
cdate=`date +"%m_%d_%Y"`
DATE=`date +"%Y%m%d"`
rdir=`pwd`

# get time of startup
res1=$(date +%s.%N)

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
bldblu=${txtbld}$(tput setaf 4) #  blue
bldppl=${txtbld}$(tput setaf 5) #  purple
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

DEVICE="$1"
RELEASE="$2"
OFFICIAL="$3"
CLEAN="$4"

# we don't allow scrollback buffer
echo -e '\0033\0143'
clear

echo -e $red""$txtrst"    ______ "$bldcya"   ______"$bldppl"    __   __ "$bldblu" ______    "$bldgrn"__       "$bldylw"______  "$txtrst"  "
echo -e $red""$txtrst"   /\  == \ "$bldcya" /\  ___\ "$bldppl" /\ \ / /"$bldblu" /\  __ \  "$bldgrn"/\ \     "$bldylw"/\__  _\ "$txtrst"  "
echo -e $red""$txtrst"   \ \  __< "$bldcya" \ \  __\ "$bldppl" \ \ \'/ "$bldblu" \ \ \/\ \ $bldgrn\ \ \____"$bldylw"\/_/\ \/ "$txtrst"  "
echo -e $red""$txtrst"    \ \_\ \_\ "$bldcya"\ \_____\ "$bldppl"\ \__|  "$bldblu" \ \_____\ "$bldgrn"\ \_____\  "$bldylw"\ \_\ "$txtrst"  "
echo -e $red""$txtrst"     \/_/ /_/"$bldcya"  \/_____/"$bldppl"  \/_/    "$bldblu" \/_____/  "$bldgrn"\/_____/   "$bldylw"\/_/ "$txtrst"  "
echo -e $txtrst""$txtrst" "

# cleaning up the Mess here
if [ "$CLEAN" == "clean" ]
then
    echo -e "${cya}Cleaning Up ${txtrst}"
    rm out/target/product/grouper/system/build.prop;
    rm out/target/product/mako/system/build.prop;
    rm out/target/product/i9100/system/build.prop;
    rm out/target/product/i9100g/system/build.prop;
    rm out/target/product/i9300/system/build.prop;
    rm out/target/product/n7000/system/build.prop;
    rm out/target/product/n7100/system/build.prop;
    rm out/target/product/jfltetmo/system/build.prop;
    rm out/target/product/jfltecan/system/build.prop;
    rm out/target/product/jflteusc/system/build.prop;
    rm out/target/product/m7/system/build.prop;
    rm out/target/product/find5/system/build.prop;
    rm out/target/product/d710/system/build.prop;
    rm out/target/product/n8000/system/build.prop;
    rm out/target/product/n8010/system/build.prop;
    rm out/target/product/n8013/system/build.prop;
    rm out/target/product/maguro/system/build.prop;
    rm out/target/product/manta/system/build.prop;
    rm out/target/product/i9500/system/build.prop;
    make clean ;
    echo -e ""
    make clobber ;
    echo -e "Let's start the build !"
else
    echo -e "NOT Cleaning"
fi

# Remove previous build info
echo "Removing previous build.prop"

rm out/target/product/"$DEVICE"/system/build.prop;

# Start the Build
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh

# lunch device
echo -e ""
echo -e "${bldblu}Lunching your device ${txtrst}"
lunch "revolt_"$DEVICE"-userdebug";

echo -e ""
echo -e "${bldblu}Starting to build ReVolt ROM for the "$DEVICE" ${txtrst}"

# start compilation
brunch "revolt_"$DEVICE"-userdebug" -j16;

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"

sed -i -e 's/revolt_//' $OUT/system/build.prop
FINAL=`sed -n -e'/ro.revolt.version/s/^.*=//p' $OUT/system/build.prop`
PACKAGENIGHT=$OUT/$FINAL.zip
echo -e "${bldblu}Nightly build done ${txtrst}"
echo -e "${bldblu}Uploading to ReVolt.BasketBuild.com ${txtrst}"
ncftpput -u revolt basketbuild.com /"$DEVICE"/Nightlies "$PACKAGENIGHT"
echo -e "${bldblu}Uploading to Goo.IM ${txtrst}"
scp "$PACKAGENIGHT" johnhany97@upload.goo.im:~/public_html/ReVolt_JB_"$DEVICE"/Nightlies/
echo -e "${bldblu}Build DONE, Uploaded to BasketBuild & Goo.IM${txtrst}"
res3=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res3 - $res1) / 60"|bc ) minutes ($(echo "$res3 - $res1"|bc ) seconds) ${txtrst}"
