# Setup
This walkthrough should help you setup this component on a clean installation of LinuxCNC.

## Prerequisite
- An installation of LinuxCNC > 2.9 (2.9.4 at the time of this writing)
- The PoKeys device and motors are set up with the PoKeys configuration application. (*TODO* specify minimum)

## Getting the component
Either you copy the source directly to your LinuxCNC system or get it via Git.  
The walkthorugh is written with the assumption to use Git, with a folder name "git" in your home directory.

### Setting up Git repository
```bash
sudo apt install git-all
mkdir ~/git 
cd ~/git
git clone https://github.com/tfrei139/PoKeysMotionComponent.git
```

## Getting the PoKeysLib
To communicate with the PoKeys device, we use the manufacturers own library:

```bash
cd ~/git
git clone https://github.com/PoLabsEE/PoKeysLib
```

### Getting the dependencies
```bash
sudo apt install build-essential libusb-1.0-0 libusb-1.0-0-dev 
```

### Enabling FastUSB support 
> *TODO* find out why this step is necessary. The make file contains "-DPOKEYSLIB_USE_LIBUSB"?

Add the following snippet to each file: `PoKeysLib.h`, `PoKeysLibCore.c`, `PoKeysLibFastUSB.c`
```C
#ifndef POKEYSLIB_USE_LIBUSB	
    #define POKEYSLIB_USE_LIBUSB
#endif
```

### Building the library
```bash
cd ~/git/PoKeysLib
sudo make -f Makefile.noqmake install
```

## Enabling USB support
If you want to use a (Fast-)USB connection, you need to ensure that Linux gives you ReadWrite permissions to the device.  
Create a new file `/etc/udev/rules.d/90-usb-pokeys.rules`  
Add the content `SUBSYSTEM=="usb", ATTRS{idVendor}=="1dc3", ATTRS{idProduct}=="1001", GROUP="plugdev", MODE="664"`  
Ensure your user is in the `plugdev` group
```bash
sudo usermod -a -G plugdev <username>
```
Restart the computer (In theory you can run `udevadm control --reload-rules`, but didn't work for me).

## Compiling the components
```bash
cd ~/git/PoKeysMotionComponent/source
sudo halcompile --install PoKeysController.comp
sudo halcompile --install PoKeysMotionBuffer.comp
```

## Copying and adapting the configuration
Copy the example configuration from `~/git/PoKeysMotionComponent/configuration` to `~/linuxcnc/configuration`.

In the "hal" file:
1. Adapt the serial number `setp PoKeysController.0.device-serial 0`
1. Adapt the step-scale for each axis `setp PoKeysController.0.axis.D.step-scale 800.0` and `setp PoKeysMotionBuffer.0.axis.D.step-scale 800.0` (1mm == 800 pulses)

In the "ini" file:
1. Choose your preferred UI "axis" for a simple standard UI, "gmoccapy" for a touchscreen optimized one
1. Adapt the `[AXIS_]` and `[JOINT_]` sections to match your set up
