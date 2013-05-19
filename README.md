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

     . build/envsetup.sh && brunch DEVICE


- Device: Write the code-name of your device (Must be a supported device)

Example:

     . build/envsetup.sh && brunch mako

This will build ReVolt ROM for the mako (Nexus 4)
