# Unofficial Octavi IFR-1 X-Plane/FlyWithLua Script
Supports IFR-1 on unsupported platforms. Tested on macOS.

## About
I didn't pay enough attention when I bought it, and when it
arrived three days before Christmas, I was dismayed to find
out that the plugins only support Windows. There was some
mention of an Lua script that was available on request to
support Mac and Linux, but of course it was too short notice
to get a copy to play with over the holiday. Plus, it's weird 
that they don't make it available to download, even
with a caveat like "this is totally unsupported, don't email
us if you have problems".

So I got a bonus project for the holiday, and I got to work
figuring out how to write Lua, how to read and write USB HID
data, and how the IFR-1 works under the hood.

## Install
1. Install [FlyWithLua](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/)
2. Download and copy `octavi-ifr-1.lua` into FlyWithLua's `Scripts` directory.

## Usage
The script attempts to open the IFR-1 on load and periodically rechecks. It should automatically connect or reconnect if the IFR-1 is not plugged on start or if it is unplugged and replugged.

On COM1, COM2, NAV1, NAV2, and AP, pressing the knob button will activate shift mode. The leds will all light up and wink to indicate shift mode. Shift mode generally makes the knob adjust the value printed in blue above the mode button, but there are some bonus hidden features.

Most knobs and buttons will cause a message to be printed to the upper right part of the main display.

### COM1/HDG
Adjust the COM1 standby frequency. Press the swap button to swap to active.

In shift mode, the knob adjusts the heading bug. Pressing the OBS/HDG button will sync the vacuum-driven heading indicator to the compass heading.

### COM2/BARO
Adjust the COM2 standby frequency. Press the swap button to swap to active.

In shift mode, the knob adjusts the pilot's altimeter setting. Pressing the VNAV/ALT button syncs the altimeter to the current sea level setting at the aircraft position (which is not necessarily the current value for the nearest airport)

### NAV1/CRS1
Adjust the NAV1 standby frequency. Press the swap button to swap to active.

In shift mode, adjusts the NAV1 OBS

### NAV2/CRS2
Adjust the NAV2 standby frequency. Press the swap button to swap to active.

In shift mode, adjusts the NAV2 OBS (NOTE: this is set up to adjust the _copilot_ NAV2 OBS, because the instrument in X-Plane's default steam C172 is apparently configured to use the copilot dataref.)

### FMS1, FMS2
These are the main modes that are set up to be specific to aircraft with GNS430/530 navigators, as they use 430-specific X-Plane commands. In these modes, the bottom and right side buttons and the knobs (including clicking the knob for cursor) operate the navigators. I developed and tested the script with the default steam C172, which is what I use for instrument practice right now.

### AP
The LEDs indicate the AP status, and the bottom buttons select the AP mode. The little knob adjust altitude preselect, and the big knob adjusts vertical speed target.

VS to preselected ALT can be activate by pressing ALT while holding VS (press and hold VS, then press ALT while still holding VS, then release both)

In shift mode, pressing APR/FPL will active backcourse mode.

### XPDR/MODE
Adjust the transponder code. The big knob adjusts the first two digits, and the little knob the last two.

Pressing the knob button in XPDR mode cycles the transponder through OFF, STBY, ON, and ALT modes.
Pressing the AP/CDI activates IDENT on the transponder and the LED illuminates when transmitting IDENT.

## Support
None.