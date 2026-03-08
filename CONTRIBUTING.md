# How to contribute

## Testing
This component has reached the main goals that were initially defined. However for as long as there is not enough testing feedback of different setups, it cannot be considered "stable".

If you give this component a try, feedback is very welcome. Whether it worked for you, or if it was too confusing or anything else.  
To give feedback please head to the [issues page](https://github.com/tfrei139/PoKeysMotionComponent/issues), create a new issue and tag it "feedback".

## Code or configuration review
As I started out with zero knowledge of LinuxCNC some configurations, settings or integration in linuxCNC may not be state-of-the-art.  
If you have in depth know-how and find something, please create an issue, so I can address it.

## Backlog
This list is mainly intended as a reminder for myself.

- Testing
    - motion buffer in error situations
    - probing
    - soft limits
- IO
    - Matrix-Keyboard (up to 8x8 should be basically free with `PK_DigitalIOSetGet`)
- Technical
    - Split up code base & Merge components using `hal_export_funct`?
    - Velocity mode
- Provide more example configurations
    - Complete MPG example