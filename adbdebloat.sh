#!/bin/bash

adb push /htc10debloat.sh /media/debloat.sh
adb shell /system/bin/sh /media/debloat.sh
