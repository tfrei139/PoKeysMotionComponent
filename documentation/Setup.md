# Setup
This walkthrough should help you setup this component on a clean installation of LinuxCNC.  
For installation of LinuxCNC, see the [its own documentation](https://linuxcnc.org/docs/stable/html/getting-started/getting-linuxcnc.html)

## Prerequisite
- An installation of LinuxCNC > 2.9 (2.9.8 at the time of this writing) (*TODO* would this work with live-linuxCNC too?)
- The PoKeys device and motors are set up with the PoKeys configuration application. (*TODO* specify minimum)

## Getting the component
Either you copy the source directly to your LinuxCNC system or get it via Git.  
The walkthrough is written with the assumption to use Git, with a folder name "git" in your home directory.

### Setting up Git and repository
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
> By default the PoKeysLib is not built with FastUsb support.  
> I assume the original library uses a different compiler or local settings, that do not match a default LinuxCNC/debian installation.

In the `Makefile.noqmake` add this parameter
```makefile
CFLAGS=-fPIC -DPOKEYSLIB_USE_LIBUSB
```

Add `libusb-1.0/` to the include in both files: `PoKeysLib.h`, `PoKeysLibFastUSB.c`
```C
//#define POKEYSLIB_USE_LIBUSB
#ifdef POKEYSLIB_USE_LIBUSB
    #include "libusb-1.0/libusb.h"
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
./scripts/compile.sh
```

## Copying and adapting the configuration
Copy the example configuration from `~/git/PoKeysMotionComponent/configuration` to `~/linuxcnc/configs`.
or run the script
```bash
./scripts/configuration_example.sh
```

In the "ini" file:
1. Adapt the serial number `DEVICE_SERIAL = 0`
1. Adapt the step-scale for each axis `AXIS0_STEP_SCALE = 800.0` (example given: 1mm == 800 pulses for the first axis)
1. Choose your preferred UI "axis" for a simple standard UI, "gmoccapy" for a touchscreen optimized one
1. Adapt the `[AXIS_]` and `[JOINT_]` sections to match your set up

In the "hal" file:
1. Add or remove the `Axis` sections to match your number of used axes and joints

### Setting up input and output pins
In the ini file, you can define up to 10 digital input, output pins each.
Additonally up to 6 PWM pins are supported.
These pins need to be configured manually, since they can be set up with different capabilities on the PoKeys device.  

The SSR1/2, Relay1/2 and OC1..4 outputs are predefined, and only need to be wired up in the hal file.

Example of digital in, example "probe", first "ini" then "hal" file
```INI
INPUT_PIN_0 = 19
```
```
net probe-in     <=  PoKeysController.0.io.input-pin.0
net probe-in     =>  motion.probe-input
```
`INPUT_PIN_0 = 19` defines that `input-pin.0` uses PoKeys pin 19 for probing.  
Note: pins in the "ini" file are 1-based.

Example of out, example "spindle", only "hal" file
```
net spindle-enable <= spindle.0.on
net spindle-enable => PoKeysController.0.io.solid-state-relay.0
```
`solid-state-relay.0` stands for SSR1 on the PoKeys.

Note: PoKeys57CNCpro4x25 uses a slightly different order. See protocol definition.

### Setting up PWM pins
For each PWM channel/pin you want to use, add the `PWM_PIN_D` parameter.  
PoKeys puts the 6 PWM pins into channels numbered 0-5. With the pin number it is verified that the configurations matches the setup on the device.
```INI
PWM_PIN_0 = 17
```
```
net pwm-value => PoKeysController.0.io.pwm-pin.0
```
The "io.pwm-pin.D" accepts a floating point value from 0% to 100% duty cycle.


### Setting up Encoder pins
The PoKeys device offers up to 26 encoders. By default up to 5 can be configured in the ini file.  
ini options:
```INI
ENCODER_PIN_0 = 1
ENCODER_PIN_0_SCALE = 20.0
ENCODER_PIN_0_INDEX_PIN = 9
ENCODER_PIN_0_INDEX_PIN_INVERT = true
```
hal pins:
```
io.encoder.0.count
io.encoder.0.index
io.encoder.0.cps
io.encoder.0.vps
```

`ENCODER_PIN_0 = 1` defines that PoKeys encoder 1 is used.  
`io.encoder.0.count` returns the current encoder count.  
`io.encoder.0.cps` stands for "counts per second".  
`io.encoder.0.vps` stands for "velocity per second", where velocity is calculated from counts divided by scale factor. If you have a rotary encoder with 20 steps per revolution, `ENCODER_PIN_0_SCALE = 20.0` defines that 20 steps per second equal one revolution per second. The `ENCODER_PIN_0_SCALE` is optional, if left out `cps` and `vps` will be equal.  
`ENCODER_PIN_0_INDEX_PIN = 9` is optional and defines the pin used as index position. `ENCODER_PIN_0_INDEX_PIN_INVERT = true` and will invert the signal whether high or low is considered indexed.  
`io.encoder.0.index` returns the current index signal.

Note on indexing: The component will not handle the index high in any special way. The PoKeys device may be set up to reset the count, which may lead to undefined behavior of the hal pins.  

Note on implementation: The different types of encoders supported by PoKeys are abstracted away. See also the [Design document -> Encoders](DesignDocument.md).