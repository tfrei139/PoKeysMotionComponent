# PoKeysMotionComponent
LinuxCNC component to use a PoKeysCNC board for motion and simple IO

### State of the component
**Experimental**. Tested with 5'000 line gcode file, ~20 minutes run time, with the given example configuration.

## Introduction
This component aims to provide a simple integration of a PoKeysCNC controller into LinuxCNC.  
Simple means that it does not try provide all possible functions and features of the PoKeysCNC, but focus on the motion control and necessary IO for a simple CNC machine.

The component is split into two parts: the real time motion buffer component and the user space controller component.
The communication with the PoKeys either through ethernet or USB will never be close to fast enough for a real time component.  
The motion buffer will grab the commanded positions, compute the necessary pulses, and stream it to a buffer.
The controller will read the buffer and forward it to the PoKeysCNC. This way, slight deviations in timing are unproblematic.

### Features
- 3 Axis (motor) motion control
- E-Stop
- Limit switches and override
- IO
    - All relays (example Spindle on/off)
    - Configurable digital input output pins
    - PWM pins

### Backlog
- Enable homing
- Make number of axes configurable in HAL
- Test/Extend probing
- Technical: Benchmark component
- Technical: convert to `C` component
- Allow reading encoders for jogging
- Provide more example configurations

## Setup
A walkthrough to set this component up is available here [Setup](documentation/Setup.md)

## Documentation
Additional information about the design decisions and behaviour can be found here [Design document](documentation/DesignDocument.md).

## License
This project is licensed under the GNU GENERAL PUBLIC LICENSE V2. See [LICENSE](LICENSE).