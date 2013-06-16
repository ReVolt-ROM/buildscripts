ReVolt ROM
=====================

Syncing Sources
---------------
Intialize your computer by syncing with latest sources via this command :

    repo init -u git://github.com/ReVolt-ROM/platform_manifest.git -b jb-mr1

then run this command to get the actual sources :

    repo sync

Keep in mind it might take a lot of time depending on your internet connection

Building ReVolt ROM
-------------------

Now you can run the command:

     . build_revolt.sh DEVICE SYNC CLEAN THREADS


- DEVICE: Write the code-name of your device (Must be a supported device)
- SYNC: Whether to sync or not, write the word "sync" if you want it to sync
- CLEAN: Whether to clean before build or not
- THREADS: How many cores to use in the build

Example:

     . build_revolt.sh mako sync noclean 4

This will sync the latest sources, NOT clean the out directory, start building ReVolt ROM for the Nexus 4 with 4 threads

     . build_revolt.sh i9100 nosync clean 12

This will NOT sync the sources, clean the out directory, start building ReVolt ROM for the Samsung Galaxy S2 I9100 with 12 cores
