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

## Original test system specs
ASUS all-in-one V161, BIOS V308, Intel Celeron N4000 1.1 GHz up to 2.6 GHz, 2 cores.  
PoKeys57CNC, V1.3, Firmware V4.4.19  
LinuxCNC 2.9.4 PREEMPT-RT  
Latency Test, Max Jitter: Servo Thread 53'936ns, Base Thread 79'713ns

## Userspace components do not support personality
[LinuxCNC Issue 1089](https://github.com/LinuxCNC/linuxcnc/issues/1089)