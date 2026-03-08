# PoKeysMotionComponent
LinuxCNC component to use a PoKeys controller for motion and simple IO

### State of the component
**Prototype**. Tested LinuxCNC 2.9.4 and 2.9.8 on a Pokeys57CNC with 5'000 line gcode file, ~20 minutes run time, with the given example configuration.

## Introduction
This component aims to provide a simple integration of a PoKeys IO/CNC controller into LinuxCNC.  
Simple means that it does not try provide all possible functions and features of the PoKeys controller, but focus on the motion control and necessary IO for a simple CNC machine.

PoKeys pulse engine offers high level functions on its own, such as homing, probing or jogging. However trying to match and adapt those functions to LinuxCNCs design is a fruitless effort.  
LinuxCNC *is* the controller and will provide the logic for all functions. PoKeys is reduced to IO and motor controller.  

The component is split into two parts: the real time motion buffer component and the user space controller component.
The communication with the PoKeys either through ethernet or USB will never be close to fast enough for a real time component.  
The motion buffer will grab the commanded positions, compute the necessary pulses, and stream it to a buffer.
The controller will read the buffer and forward it to the PoKeys pulse engine. This way, slight deviations in timing are unproblematic.

### Features
- 1-8 Axis (motor) motion control
- E-Stop
- Limit switches and override
- Homing
- IO
    - All relays (example spindle on/off)
    - Configurable digital input/output pins
    - PWM pins (example spindle speed control)
    - Basic, fast and ultra fast encoders (example MPG jogging)

## Setup
A walkthrough to set this component up is available here [Setup](documentation/Setup.md)

## Documentation
Additional information about the design decisions and behaviour can be found here [Design document](documentation/DesignDocument.md).

## License
This project is licensed under the GNU GENERAL PUBLIC LICENSE V2. See [LICENSE](LICENSE).