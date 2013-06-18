#!/bin/bash

ydate=$(date -d '1 day ago' +"%m/%d/%Y")
cdate=`date +"%m_%d_%Y"`
DATE=`date +"%Y%m%d"`
rdir=`pwd`

DEVICE="$1"
SYNC="$2"
CLEAN="$3"
THREADS="$4"

# Start timinig
res1=$(date +%s.%N)

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             #  Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
bldblu=${txtbld}$(tput setaf 4) #  blue
bldppl=${txtbld}$(tput setaf 5) #  purple
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             #  Reset

# we don't allow scrollback buffer
echo -e '\0033\0143'
clear

# REVOLT
echo -e $red""$txtrst"    ______ "$bldcya"   ______"$bldppl"    __   __ "$bldblu" ______    "$bldgrn"__       "$bldylw"______  "$txtrst"  "
echo -e $red""$txtrst"   /\  == \ "$bldcya" /\  ___\ "$bldppl" /\ \ / /"$bldblu" /\  __ \  "$bldgrn"/\ \     "$bldylw"/\__  _\ "$txtrst"  "
echo -e $red""$txtrst"   \ \  __< "$bldcya" \ \  __\ "$bldppl" \ \ \'/ "$bldblu" \ \ \/\ \ $bldgrn\ \ \____"$bldylw"\/_/\ \/ "$txtrst"  "
echo -e $red""$txtrst"    \ \_\ \_\ "$bldcya"\ \_____\ "$bldppl"\ \__|  "$bldblu" \ \_____\ "$bldgrn"\ \_____\  "$bldylw"\ \_\ "$txtrst"  "
echo -e $red""$txtrst"     \/_/ /_/"$bldcya"  \/_____/"$bldppl"  \/_/    "$bldblu" \/_____/  "$bldgrn"\/_____/   "$bldylw"\/_/ "$txtrst"  "
echo -e $txtrst""$txtrst" "

# Cleaning up the Mess here
if [ "$CLEAN" == "clean" ]
then
    echo -e "${cya}Cleaning Up ${txtrst}"
    make clobber ;
    echo -e "Let's start the build !"
else
    echo -e "Not Cleaning"
fi

# Remove previous build info
echo "Removing previous build.prop"
rm out/target/product/"$DEVICE"/system/build.prop;

# Sync Latest Sources
if [ "$SYNC" == "sync" ]
then
    echo -e "${cya}Syncing Latest Sources ${txtrst}"
    repo sync -j"$THREADS";
    echo -e "${cya}Latest Sources synced ${txtrst}"
else
    echo -e "Starting the Build"
fi

export RV_PRODUCT="$DEVICE"

# Start the Build
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh

# Lunch Specified Device
echo -e ""
echo -e "${bldblu}Lunching your device ${txtrst}"
lunch "revolt_$DEVICE-userdebug";

echo -e ""
echo -e "${bldblu}Starting to build ReVolt ROM ${txtrst}"

# Let ReVolt start compiling
brunch "revolt_$DEVICE-userdebug" -j"$THREADS";

# REVOLT
echo -e $red""$txtrst"    ______ "$bldcya"   ______"$bldppl"    __   __ "$bldblu" ______    "$bldgrn"__       "$bldylw"______  "$txtrst"  "
echo -e $red""$txtrst"   /\  == \ "$bldcya" /\  ___\ "$bldppl" /\ \ / /"$bldblu" /\  __ \  "$bldgrn"/\ \     "$bldylw"/\__  _\ "$txtrst"  "
echo -e $red""$txtrst"   \ \  __< "$bldcya" \ \  __\ "$bldppl" \ \ \'/ "$bldblu" \ \ \/\ \ $bldgrn\ \ \____"$bldylw"\/_/\ \/ "$txtrst"  "
echo -e $red""$txtrst"    \ \_\ \_\ "$bldcya"\ \_____\ "$bldppl"\ \__|  "$bldblu" \ \_____\ "$bldgrn"\ \_____\  "$bldylw"\ \_\ "$txtrst"  "
echo -e $red""$txtrst"     \/_/ /_/"$bldcya"  \/_____/"$bldppl"  \/_/    "$bldblu" \/_____/  "$bldgrn"\/_____/   "$bldylw"\/_/ "$txtrst"  "
echo -e $txtrst""$txtrst" "

# Time elapsed for a full set of builds
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
