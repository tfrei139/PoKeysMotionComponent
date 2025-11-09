# Code notes

## Design decision: Split of real time and user component
Initally I tried using only one userspace component using the internal motion planner of the PoKeysCNC. However the refresh speed of the meant that multiple miliseconds passed between each updated. And the internal motion planner would not know if the next instruction would be followed by a stop or a longer distance.  
The alternative to the internal motion planner is the buffered mode, where you send the raw pulses for each motor required. PoLabs use this mechanism for their Mach3 (and probably Mach4) plugins.  
LinuxCNC already has a component that grabs HAL pins from the servo thread and relays it further, see [sampler.c and sampler_usr.c](https://github.com/LinuxCNC/linuxcnc/blob/master/src/hal/components/sampler.c).
I used the same approach for buffering the motion. As consequence we will always have a small following error.

## Design decision: Instance vs singleton
There is no technical limitation that you could use multiple PoKeysCNC devices. I do not find any use case for it, but why not allow it.  
The component is mostly written to support multiple instances. However currently it would not work.

## Design decision: Motion only streamed if necessary
As the component was developed, creating distinct states of being enabled and in motion made more sense to me.
When to motion stops and restarts, we ensure that we have filled the buffer again.

It would be possible to stream the motion as soon as the machine is enabled in the UI. The benfit would be that there are less states to handle.
The drawback, that we consistently need to send unnecessary data. And add potentially more overhead to the single existing state.  

During my tests I did get occasional high cycle times for the user component (I assume due to the hardware). So the robustness of the mechanism is appreciated.

## Design decision: Parametrization using HAL
While a userpace component can read from the machine ini file, an RT component cannot.  
So to keep the configuration consistent for both, both will be configured using the HAL pins and parameters.

Old example:  
Requires `option extra_link_args "... -llinuxcncini";`
```C
const char* ini_path = getenv("INI_FILE_NAME");
    
FILE* ini_file_ptr = fopen(ini_path, "r");

if (ini_file_ptr == NULL) {
    rtapi_print_msg(RTAPI_MSG_ERR, "FAILED to read INI '%s'\n", ini_path);
    return false;
}

/* make sure file is closed on exec() */
//int fd = fileno(ini_file_ptr); // TODO check actual effect
//fcntl(fd, F_SETFD, FD_CLOEXEC);

const char* section = "POKEYS"; // TODO append instance number. How to get instance number/name?
const char* tag = "DEVICE_SERIAL"; 

const char* tmpstr = iniFind(ini_file_ptr, tag, section);
int deviceSerial = 0;
int iniRead = iniFindInt(ini_file_ptr, tag, section, &deviceSerial);
rtapi_print_msg(RTAPI_MSG_ERR, "Got device serial from INI '%d',%d\n", deviceSerial, iniRead);

fclose(ini_file_ptr);
```

## Relays, PWM behavior under E-Stop
The relay pins are only "in". If we have a failure setting the signal on device side, or we shut down due to E-Stop, the pins will show the wrong state on LinuxCNC side.
"io" pins are not always possible, for example the spindle signal does not support io.

In case of an E-Stop, I will also turn off all relays and PWM output. Assuming they trigger a part of the machine that should also stop in E-Stop conditions.
In this case I prefer to err on the side of caution and allow a mismatch. 

The other option would be to put this responsibilty to LinuxCNC and only forward the E-Stop pin, otherwise behaving normal.

## E-Stop pin
According to the documentation, the designated E-Stop connector and the pendant E-Stop (Pin 52) are wired in series.
I did not find out how to read the designated pin, so I read the pin 52 as E-Stop pin.

Note: `PK_PEv2_AdditionalParametersGet()`, returned pin 62 for `device.PEv2.EmergencyInputPin`?!