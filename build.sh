#!/bin/bash

# Set output directory
outdir=/raid/johnhany97/nightlies
mkdir -p $outdir

ydate=$(date -d '1 day ago' +"%m/%d/%Y")
sdate="$2"
cdate=`date +"%m_%d_%Y"`
DATE=`date +"%Y%m%d"`
rdir=`pwd`

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

echo -e $red""$txtrst"    ______ "$bldcya"   ______"$bldppl"    __   __ "$bldblu" ______    "$bldgrn"__       "$bldylw"______  "$txtrst"  "
echo -e $red""$txtrst"   /\  == \ "$bldcya" /\  ___\ "$bldppl" /\ \ / /"$bldblu" /\  __ \  "$bldgrn"/\ \     "$bldylw"/\__  _\ "$txtrst"  "
echo -e $red""$txtrst"   \ \  __< "$bldcya" \ \  __\ "$bldppl" \ \ \'/ "$bldblu" \ \ \/\ \ $bldgrn\ \ \____"$bldylw"\/_/\ \/ "$txtrst"  "
echo -e $red""$txtrst"    \ \_\ \_\ "$bldcya"\ \_____\ "$bldppl"\ \__|  "$bldblu" \ \_____\ "$bldgrn"\ \_____\  "$bldylw"\ \_\ "$txtrst"  "
echo -e $red""$txtrst"     \/_/ /_/"$bldcya"  \/_____/"$bldppl"  \/_/    "$bldblu" \/_____/  "$bldgrn"\/_____/   "$bldylw"\/_/ "$txtrst"  "
echo -e $txtrst""$txtrst" "

# Set version
ver=nightly-"$DATE"
export RV_NIGHTLY="$DATE"

# Remove previous build info
echo "Removing previous build.prop"
rm out/target/product/mako/system/build.prop;
rm out/target/product/grouper/system/build.prop;
rm out/target/product/maguro/system/build.prop;
rm out/target/product/manta/system/build.prop;
rm out/target/product/find5/system/build.prop;
rm out/target/product/i9100/system/build.prop;
rm out/target/product/i9100g/system/build.prop;
rm out/target/product/i9300/system/build.prop;
rm out/target/product/yuga/system/build.prop;
rm out/target/product/odin/system/build.prop;
rm out/target/product/n7000/system/build.prop;
rm out/target/product/n7100/system/build.prop;
rm out/target/product/m7ul/system/build.prop;
rm out/target/product/m7att/system/build.prop;
rm out/target/product/m7tmo/system/build.prop;
rm out/target/product/m7spr/system/build.prop;
rm out/target/product/jfltecan/system/build.prop;
rm out/target/product/jfltetmo/system/build.prop;
rm out/target/product/jfltespr/system/build.prop;
rm out/target/product/jflteusc/system/build.prop;
rm out/target/product/jfltevzw/system/build.prop;
rm out/target/product/jflteatt/system/build.prop;
rm out/target/product/n8000/system/build.prop;
rm out/target/product/n8013/system/build.prop;
rm out/target/product/jfltexx/system/build.prop;

# Generate Changelog

echo "Generating Changelog"

# Check the date start range is set
if [ -z "$sdate" ]; then
sdate=${ydate}
fi

# Find the directories to log
find $rdir -name .git | sed 's/\/.git//g' | sed 'N;$!P;$!D;$d' | while read line
do
cd $line
    # Test to see if the repo needs to have a changelog written.
    log=$(git log --pretty="%an - %s" --no-merges --since=$sdate --date-order)
    project=$(git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///' | sed 's/\.git//')
    if [ -z "$log" ]; then
echo "Nothing updated on $project, skipping"
    else
        # Prepend group project ownership to each project.
        origin=`grep "$project" $rdir/.repo/manifest.xml | awk {'print $4'} | cut -f2 -d '"'`
        if [ "$origin" = "aokp" ]; then
             proj_credit=AOKP
        elif [ "$origin" = "aosp" ]; then
             proj_credit=AOSP
        elif [ "$origin" = "cm" ]; then
             proj_credit=CyanogenMod
        elif [ "$origin" = "faux" ]; then
             proj_credit=Faux123
        elif [ "$origin" = "revolt" ]; then
             proj_credit=ReVolt
        elif [ "$origin" = "muppets" ]; then
              proj_credit=TheMuppets
        else
              proj_credit=""
        fi
        # Write the changelog
        echo "$proj_credit Project name: $project" >> "$rdir"/changelog.txt
        echo "$log" | while read line
        do
echo " -$line" >> "$rdir"/changelog.txt
        done
echo "" >> "$rdir"/changelog.txt
    fi
done

# Create Version Changelog
if [ "$RELEASE" == "nightly" ]
then
echo "Generating and Uploading Changelog for Nightly"
    cp changelog.txt changelog_"$DATE".txt
    ncftpput -f login.cfg /changelogs/nightlies changelog_"$DATE".txt
else
echo "Generating and Uploading Changelog for Official Release"
    cp changelog.txt changelog_"$RV_BUILD".txt
    ncftpput -f login.cfg /changelogs changelog_"$RV_BUILD".txt
fi

# Switch to the build tree, clean and sync
cd /raid/johnhany97/revolt
rm -rf out
repo sync

# Build and upload some devices
for dev in mako grouper maguro manta find5 i9100 i9100g i9300 yuga odin n7000 n7100 m7ul m7att m7tmo m7spr jfltecan jfltetmo jfltespr jflteusc jfltevzw jflteatt n8000 n8013 jfltexx janice; do
        export RV_PRODUCT=$dev
        android-build -C -v $ver -o $outdir revolt_$dev-userdebug
        if [ $? -eq 0 ]; then
                ncftpput -f login.cfg /$dev/Nightlies/ $outdir/revolt_$dev-$ver.zip
                scp $outdir/revolt_$dev-$ver.zip johnhany97@upload.goo.im:~/public_html/ReVolt_JB_$dev/Nightlies/
                rm -rf $outdir/revolt_$dev-$ver.zip
        fi
done

# Time elapsed for a full set of builds
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
