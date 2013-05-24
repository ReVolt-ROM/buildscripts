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

echo -e "Begin building ReVolt for Samsung Devices"

# i9100

rm out/target/product/i9100/system/build.prop;
. build_revolt.sh i9100 nightly

# i9100g

rm out/target/product/i9100g/system/build.prop;
. build_revolt.sh i9100g nightly

# i9300

rm out/target/product/i9300/system/build.prop;
. build_revolt.sh i9300 nightly

# n7000

rm out/target/product/n7000/system/build.prop;
. build_revolt.sh n7000 nightly

# jfltetmo

rm out/target/product/jfltetmo/system/build.prop;
. build_revolt.sh jfltetmo nightly

# jfltecan

rm out/target/product/jfltecan/system/build.prop;
. build_revolt.sh jfltecan nightly

# jflteusc

rm out/target/product/jflteusc/system/build.prop;
. build_revolt.sh jflteusc nightly

# jfltespr

rm out/target/product/jfltespr/system/build.prop;
. build_revolt.sh jfltespr nightly

# n8000

rm out/target/product/n8000/system/build.prop;
. build_revolt.sh n8000 nightly

# n8013

rm out/target/product/n8013/system/build.prop;
. build_revolt.sh n8013 nightly
