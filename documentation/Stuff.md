## USB utils
```bash
sudo apt install usbview
sudo apt install usbutils
```

## PoKeys under LinuxCNC
Other repository providing wider support for IO tasks: [PokeysLibComp](https://github.com/zarfld/LinuxCnc_PokeysLibComp)

See also [this thread](https://forum.linuxcnc.org/24-hal-components/29816-pokeys-hal-driver) on PoKeys under LinuxCNC.

## PokeysLib mirror?
There are two separate repositories for the same code:  
[PoLabs](https://github.com/PoLabsEE/PoKeysLib)  
[Matevž Bošnak](https://bitbucket.org/mbosnak/pokeyslib/src/master/)

## PoKeys protocol definition
[PoLabs downloads](https://www.poscope.com/downloads-manuals/)  
[Protocol specification](https://www.poscope.com/wp-content/uploads/downloads/Pokeys/Manuals/PoKeys%20-%20protocol%20specification.pdf)  
[Pin layout explained](https://blog.poscope.com/pokeys57cnc-pinout-explained/)

### Encoder
PoKeys supports up to 25 'normal' encoders, 1 kHz/1ms,  
Pins are manually set to A+B channel. No indexing (resetting count) from PoKeys side.

3 fast encoders, 100 kHz/10μs  
Pins 1+2 as encoder 1,  pins 5+6 as encoder 2,  pins 15+16 as encoder 3, index pins 9, 10, 11 respectively.

One ultra fast encoder, from 25 kHz up to 5 MHz, 40μs to 0.2μs. Depending on settings.  
Pins 8+12 as encoder 25, index pin 13.

## How to wire up an Estop
https://forum.linuxcnc.org/24-hal-components/37906-an-e-stop-hal-and-an-overall-how-things-work-series  
https://forum.linuxcnc.org/39-pncconf/25862-configuring-estop-latch  
https://forum.linuxcnc.org/47-hal-examples/28096-estop-latch  
https://www.youtube.com/watch?v=hVkNtq4C1F8&t=1849s  

## Component logging
Using `rtapi_set_msg_level()` will only set the level for the current component. Tried with two different userspace components.  
Maybe rt components behave differently.

When the rt component logs an error it will also show up in gmoccapy. The gmoccapy logs themselves will not include messages from other components. No idea where to get the rt debug logs.  
TODO What is LinuxCNCs component logging concept?  
[Semi-relevant forum entry](https://forum.linuxcnc.org/38-general-linuxcnc-questions/35916-where-are-the-f-ng-rtapi-print-msg-rtapi-msg-info-messages)

## Test system specs
### Original development system
ASUS all-in-one V161, BIOS V308, Intel Celeron N4000 1.1 GHz up to 2.6 GHz, 2 cores.  
PoKeys57CNC, V1.3, Firmware V4.4.19  
LinuxCNC 2.9.4 PREEMPT-RT  
Latency Test, Max Jitter: Servo Thread 53'936ns, Base Thread 79'713ns

### Raspberry Pi system
Raspberry Pi 5, 8GB, 32GB SanDisk Ultra MicroSD
PoKeys57CNC, V1.3, Firmware V4.4.19  
Raspios-lcnc-2.9.8-trixie  
Latency Test, Max Jitter: Servo Thread 43'123ns, Base Thread 38'017ns

## Userspace components do not support personality
[LinuxCNC Issue 1089](https://github.com/LinuxCNC/linuxcnc/issues/1089)

## Performance tuning
### Disable Bluetooth
> sudo touch /etc/modprobe.d/bluetooth-blacklist.conf

Edit, add
```
blacklist btusb
blacklist bluetooth
```
> sudo update-grub
