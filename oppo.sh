#!/bin/bash

echo -e $red""$txtrst"    ______ "$bldcya"   ______"$bldppl"    __   __ "$bldblu" ______    "$bldgrn"__       "$bldylw"______  "$txtrst"  "
echo -e $red""$txtrst"   /\  == \ "$bldcya" /\  ___\ "$bldppl" /\ \ / /"$bldblu" /\  __ \  "$bldgrn"/\ \     "$bldylw"/\__  _\ "$txtrst"  "
echo -e $red""$txtrst"   \ \  __< "$bldcya" \ \  __\ "$bldppl" \ \ \'/ "$bldblu" \ \ \/\ \ $bldgrn\ \ \____"$bldylw"\/_/\ \/ "$txtrst"  "
echo -e $red""$txtrst"    \ \_\ \_\ "$bldcya"\ \_____\ "$bldppl"\ \__|  "$bldblu" \ \_____\ "$bldgrn"\ \_____\  "$bldylw"\ \_\ "$txtrst"  "
echo -e $red""$txtrst"     \/_/ /_/"$bldcya"  \/_____/"$bldppl"  \/_/    "$bldblu" \/_____/  "$bldgrn"\/_____/   "$bldylw"\/_/ "$txtrst"  "
echo -e $txtrst""$txtrst" "

repo sync -j9

echo -e ""
echo -e "Remove other Device Trees"
echo -e ""
if [ -d device/htc/ ]; then
	printf "Removing HTC Device Tree \n"
        printf "\n"
	rm -r device/htc/
else
	printf "HTC Device Trees already deleted \n"
fi
if [ -d device/asus/ ]; then
	printf "Removing ASUS Device Tree \n"
        printf "\n"
	rm -r device/asus/
else
	printf "ASUS Device Trees already deleted \n"
fi
if [ -d device/lge/ ]; then
	printf "Removing LGE Device Tree \n"
        printf "\n"
	rm -r device/lge/
else
	printf "LGE Device Trees already deleted \n"
fi

echo -e "Begin building ReVolt for Oppo Devices"

# find5

rm out/target/product/find5/system/build.prop;
. build_revolt.sh find5 nightly
