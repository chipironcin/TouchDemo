# KINDLE PW3 TOUCH DEMO (KUAL Extension)

A lightweight **KUAL extension** for jailbroken Kindles designed to intercept hardware touch events on Kindle devices and display visual feedback directly on the E-ink screen using `eips`.

Tested on Kindle PaperWhite 3. Other models might use a slightly different block device name.

----------

## Overview

This project runs on a jailbroken Kindle via the Kindle Unified Application Launcher (KUAL).

It serves as a proof-of-concept for interacting with the Kindle's Linux backend. The primary goal is to demonstrate how to read and intercept raw touch input events using evtest.
    
----------

## Requirements

-   Jailbroken Kindle with touch support (tested with Kindle PW3)
-   Kindle Unified Application Launcher (KUAL) installed

----------

## Installation

1.  Install KUAL (if not already installed).
2.  Copy this extension into:
    `/extensions/`
3.  Launch from KUAL menu.
    
---------- 

## Developer Notes

Includes a modified version (source code and already compiled binary) of the program `evtest` that allows grabbing the block device to prevent the Kindle framework from also reading the touch events and react to them. This way we can safely touch the screen without the actual framework reacting to the events.


Original source code for `evtest` comes from https://github.com/freedesktop-unofficial-mirror/evtest. Slightly edited to match Kindle PW3 kernel.

Command used for compilation:
```
arm-linux-gnueabi-gcc -DKINDLE_PW3 -static -O2 -march=armv7-a -mfloat-abi=soft -o evtest evtest.c
```

Required packages: gcc-arm-linux-gnueabi libc6-dev-armel-cross

----------

## License

GPLv3
