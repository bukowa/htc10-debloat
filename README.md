
Debloating HTC 10 from unwanted apps. 
1. For `fastboot` to work you need drivers from https://adb.clockworkmod.com/, boot windows in unsigned drivers mode to install. 
2. For `adb shell` to work you can use `android studio` and install the `google usb drivers` from there. 
3. Install `twrp` on your phone (`adb flash recovery .iso`). Instruction on their site alongside tutorial on unlocking `bootloader`. https://twrp.me/htc/htc10.html
4. Boot to recovery and backup everything. If something goes wrong restore `sytem image` and `wipe -> factory defaults`.
5. First time just `wipe -> factory defaults` then mount system partition as rw inside `twrp`.
6. Execute the shell script.
7. Boot into fresh debloated HTC setup.

