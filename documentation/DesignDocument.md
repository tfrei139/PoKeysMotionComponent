# Design document

## Design decision: Split of real time and user component
Initally I tried using only one userspace component using the internal motion planner of the PoKeysCNC. However the refresh speed of the meant that multiple miliseconds passed between each updated. And the internal motion planner would not know if the next instruction would be followed by a stop or a longer distance.  
The alternative to the internal motion planner is the buffered mode, where you send the raw pulses for each motor required. PoLabs use this mechanism for their Mach3 (and probably Mach4) plugins.  
LinuxCNC already has a component that grabs HAL pins from the servo thread and relays it further, see [sampler.c and sampler_usr.c](https://github.com/LinuxCNC/linuxcnc/blob/master/src/hal/components/sampler.c).
I used the same approach for buffering the motion. As consequence we will always have a small following error.

## Design decision: Instance vs singleton
There is no technical limitation that you could use multiple PoKeys devices. I do not find any use case for it, but why not allow it.  
The component is written to support multiple instances. However currently it is untested.

## Design decision: Motion only streamed if necessary
As the component was developed, creating distinct states of being enabled and in motion made more sense to me.
When to motion stops and restarts, we ensure that we have filled the buffer again.

It would be possible to stream the motion as soon as the machine is enabled in the UI. The benfit would be that there are less states to handle.
The drawback, that we consistently need to send unnecessary data. And add potentially more overhead to the single existing state.  

During my tests I did get occasional high cycle times for the user component (I assume due to the hardware). So the robustness of the mechanism is appreciated.

## Design decision: Parametrization using HAL
The primary configuration is done in the ini file.
While a userpace component can read from the machine ini file, an RT component cannot.  
An RT component can use "personality" to parametrize the the amount of pins, but a userspace component cannot.  
So to keep the common configuration consistent for both, certain parameters will be configured using the HAL pins.

## Support of various PoKeys Board
The used PoKeys library is independent of the exact type of controller. Primary design of this component is with the external IO of a PoKeys57CNC (or PoKeys57CNCpro4x25) in mind.  
However also other controller types (example 56U, 56E, 57U, 57E) can use an internal pulse engine.  

```
- Internal: similar to basic Pulse engine, limited to 25 kHz pulse frequency at 3 channels, uses built-in circuitry and pins
- External: new in v2, limited to 125 kHz pulse frequency at 8 channels, requires external circuitry to deserialize the data to pulses
```

Note: more information on the exact setup an capabilities can be found in PoScopes documentation.

## Relays, PWM behavior under E-Stop
The relay pins are only "in". If we have a failure setting the signal on device side, or we shut down due to E-Stop, the pins will show the wrong state on LinuxCNC side.
"io" pins are not always possible, for example the spindle signal does not support io.

In case of an E-Stop, the component will also turn off all relays and PWM output. Assuming they trigger a part of the machine that should also stop in E-Stop conditions.
In this case I prefer to err on the side of caution and allow a mismatch. 

The other option would be to put this responsibilty to LinuxCNC and only forward the E-Stop pin, otherwise behaving normal.

## E-Stop pin
According to the documentation, the designated E-Stop connector and the pendant E-Stop (Pin 52) are wired in series.
I did not find out how to read the designated pin, so I read the pin 52 as E-Stop pin.

Note: `PK_PEv2_AdditionalParametersGet()`, returned pin 62 for `device.PEv2.EmergencyInputPin`?!

## Encoders
Using the `PK_DigitalIOSetGet` command will return the current encoder counts as single byte. With the exception of the Ultra fast encoder, which is reported as an integer value.  
Keeping track of the byte overflow is easily possible for the basic encoders, however fast encoders can wrap the byte multiple times in the refresh cycle time.

Since the usage of the fast encoders is discouraged according to the manual. And I observed slower response times. I choose not support the fast encoders specifically.  
They can be used, but there is **no guarantee** for the correctness of the values.

Basic encoder: with 5ms cycle time @ 1ms resolution => maximum of 5 counts of the encoder.  
Even with 4x sampling, this equals at most 20 counts. Fits a byte.  

Fast encoder: with 5ms cycle time @ 10μs resolution => maximum of 500 counts of the encoder. About twice what the byte can record.  
Using 4x Sampling would break that even more (2000 Steps per cycle).

Basic encoders do not support indexing on PoKeys, only fast and ultra fast. However with the expected velocity of the ultra fast encoder, I expect that the slow component could miss index signals.  
Due to that concern, I do not reflect a reset on index on the component side.

The pin `io.encoder.D.count` will wrap around if the maximum value of integer is reached. The "count/velocity per second" pins are stable during this wrap around.

The pin `io.encoder.0.cps` is calculated from the last 10 averages consisting of 20 values each, resulting in the average count of one second. No further filtering/stabilizing is done.