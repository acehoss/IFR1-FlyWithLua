IFR1_MODE = 0
IFR1_LAST_MODE = 0
IFR1_STATUS_TEXT = ""

IFR1_LED_AP = false
IFR1_LED_HDG = false
IFR1_LED_NAV = false
IFR1_LED_APR = false
IFR1_LED_ALT = false
IFR1_LED_VS = false

IFR1_LAST_BTN_KNOB = false
IFR1_LAST_BTN_SWAP = false
IFR1_LAST_BTN_AP = false
IFR1_LAST_BTN_HDG = false
IFR1_LAST_BTN_NAV = false
IFR1_LAST_BTN_APR = false
IFR1_LAST_BTN_ALT = false
IFR1_LAST_BTN_VS = false
IFR1_LAST_BTN_DCT = false
IFR1_LAST_BTN_MNU = false
IFR1_LAST_BTN_CLR = false
IFR1_LAST_BTN_ENT = false

IFR1_BTN_KNOB = false
IFR1_BTN_SWAP = false
IFR1_BTN_AP = false
IFR1_BTN_HDG = false
IFR1_BTN_NAV = false
IFR1_BTN_APR = false
IFR1_BTN_ALT = false
IFR1_BTN_VS = false
IFR1_BTN_DCT = false
IFR1_BTN_MNU = false
IFR1_BTN_CLR = false
IFR1_BTN_ENT = false

IFR1_MODE_SHIFT = false

IFR1_MODE_VALUE_COM1 = 0
IFR1_MODE_VALUE_COM2 = 1
IFR1_MODE_VALUE_NAV1 = 2
IFR1_MODE_VALUE_NAV2 = 3
IFR1_MODE_VALUE_FMS1 = 4
IFR1_MODE_VALUE_FMS2 = 5
IFR1_MODE_VALUE_AP   = 6
IFR1_MODE_VALUE_XPDR = 7

IFR1_LED_LAST_WRITE = 0xff

IFR1_MSG_TIME = 0.0
IFR1_OPEN_TIME = 0.0

IFR1_DEVICE = nil

DataRef("ap_on", "sim/cockpit2/autopilot/servos_on")
DataRef("ap_lateral", "sim/cockpit2/autopilot/heading_mode")
DataRef("ap_vertical", "sim/cockpit2/autopilot/altitude_mode")
DataRef("ap_appr", "sim/cockpit2/autopilot/approach_status")
DataRef("ap_vs", "sim/cockpit2/autopilot/vvi_dial_fpm", "writable")
DataRef("ap_alt", "sim/cockpit2/autopilot/altitude_dial_ft", "writable")
DataRef("xpdr_code", "sim/cockpit2/radios/actuators/transponder_code", "writable")
DataRef("nav1_obs", "sim/cockpit/radios/nav1_obs_degm", "writable")
DataRef("nav2_obs", "sim/cockpit/radios/nav2_obs_degm2", "writable")
DataRef("baro", "sim/cockpit/misc/barometer_setting", "writable")
DataRef("ap_baro", "sim/cockpit2/autopilot/barometer_setting_in_hg_alt_preselector", "writable")
DataRef("baro_current_pas", "sim/weather/region/sealevel_pressure_pas")
DataRef("heading_indicated", "sim/cockpit/misc/compass_indicated")
DataRef("dg_heading", "sim/cockpit2/gauges/indicators/heading_vacuum_deg_mag_pilot", "writable")
DataRef("xpdr_mode", "sim/cockpit2/radios/actuators/transponder_mode", "writable")
DataRef("com1_sby", "sim/cockpit2/radios/actuators/com1_standby_frequency_hz", "writable")
DataRef("com2_sby", "sim/cockpit2/radios/actuators/com2_standby_frequency_hz", "writable")
DataRef("nav1_sby", "sim/cockpit2/radios/actuators/nav1_standby_frequency_hz", "writable")
DataRef("nav2_sby", "sim/cockpit2/radios/actuators/nav2_standby_frequency_hz", "writable")
DataRef("com1_frq", "sim/cockpit2/radios/actuators/com1_frequency_hz", "writable")
DataRef("com2_frq", "sim/cockpit2/radios/actuators/com2_frequency_hz", "writable")
DataRef("nav1_frq", "sim/cockpit2/radios/actuators/nav1_frequency_hz", "writable")
DataRef("nav2_frq", "sim/cockpit2/radios/actuators/nav2_frequency_hz", "writable")
DataRef("xpdr_ident", "sim/cockpit/radios/transponder_id")
DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
DataRef("heading", "sim/cockpit/autopilot/heading_mag", "writable")
DataRef( "sim_time", "sim/network/misc/network_time_sec")

function ifr1_msg(str)
    IFR1_STATUS_TEXT = "IFR-1: " .. str
    IFR1_MSG_TIME = sim_time
    print(IFR1_STATUS_TEXT)
end

function ifr1_open()
    if IFR1_OPEN_TIME == 0.0 or IFR1_OPEN_TIME + 1.0 < sim_time then
        local was_connected = IFR1_DEVICE ~= nil
        if was_connected then
            hid_close(IFR1_DEVICE)
            IFR1_DEVICE = nil
        end
        IFR1_DEVICE = hid_open(0x4d8,0xe6d6)
        if IFR1_DEVICE ~= nil then
            hid_set_nonblocking(IFR1_DEVICE, 1)
            hid_write(IFR1_DEVICE, 11, IFR1_LED_LAST_WRITE)
            if not was_connected then
                ifr1_msg("Connected")
            end
        else
            if IFR1_OPEN_TIME == 0.0 or was_connected then
                ifr1_msg("Not connected")
            end
        end
        IFR1_OPEN_TIME = sim_time
    end
end

function ifr1_pas_to_inhg(pascals)
    local inchesMercury = pascals * 0.0002953
    return inchesMercury
end

function ifr1_round(num, numDecimalPlaces)
    local mult = 10 ^ numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
end

function ifr1_last_buttons()
    IFR1_BTN_KNOB = IFR1_LAST_BTN_KNOB
    IFR1_BTN_SWAP = IFR1_LAST_BTN_SWAP
    IFR1_BTN_AP = IFR1_LAST_BTN_AP
    IFR1_BTN_HDG = IFR1_LAST_BTN_HDG
    IFR1_BTN_NAV = IFR1_LAST_BTN_NAV
    IFR1_BTN_APR = IFR1_LAST_BTN_APR
    IFR1_BTN_ALT = IFR1_LAST_BTN_ALT
    IFR1_BTN_VS = IFR1_LAST_BTN_VS
    IFR1_BTN_DCT = IFR1_LAST_BTN_DCT
    IFR1_BTN_MNU = IFR1_LAST_BTN_MNU
    IFR1_BTN_CLR = IFR1_LAST_BTN_CLR
    IFR1_BTN_ENT = IFR1_LAST_BTN_ENT
    IFR1_LAST_MODE = IFR1_MODE
end

function ifr1_process_buttons_knobs(b0, b1, b2, k0, k1, mv)
    ifr1_last_buttons()
    IFR1_MODE = mv
    IFR1_BTN_KNOB = bit.band(b1, 0x02) > 0
    IFR1_BTN_SWAP = bit.band(b1, 0x01) > 0
    IFR1_BTN_AP =   bit.band(b1, 0x40) > 0
    IFR1_BTN_HDG =  bit.band(b1, 0x80) > 0
    IFR1_BTN_NAV =  bit.band(b2, 0x01) > 0
    IFR1_BTN_APR =  bit.band(b2, 0x02) > 0
    IFR1_BTN_ALT =  bit.band(b2, 0x04) > 0
    IFR1_BTN_VS =   bit.band(b2, 0x08) > 0
    IFR1_BTN_DCT =  bit.band(b0, 0x10) > 0
    IFR1_BTN_MNU =  bit.band(b0, 0x20) > 0
    IFR1_BTN_CLR =  bit.band(b0, 0x40) > 0
    IFR1_BTN_ENT =  bit.band(b0, 0x80) > 0

    if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
        IFR1_MODE_SHIFT = not IFR1_MODE_SHIFT
    end

    if IFR1_MODE >= IFR1_MODE_VALUE_XPDR or IFR1_MODE == IFR1_MODE_VALUE_FMS1 or IFR1_MODE == IFR1_MODE_VALUE_FMS2 or IFR1_MODE ~= IFR1_LAST_MODE then
        IFR1_MODE_SHIFT = false
    end

    if IFR1_MODE_SHIFT then
        if IFR1_MODE == IFR1_MODE_VALUE_COM1 then
            heading = ifr1_round((heading + k0 * 10 + k1),0) % 360

            if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
                ifr1_msg("sync DG")
                command_once("sim/instruments/DG_sync_mag")
            else
                ifr1_msg(string.format("Heading bug: %d, indicated: %d, dg: %d", heading, heading_indicated, dg_heading))
            end

        end

        if IFR1_MODE == IFR1_MODE_VALUE_COM2 then
            baro = ifr1_round(baro + k0 / 10.0 + k1 / 100.0, 2)
            local baro_current = ifr1_round(ifr1_pas_to_inhg(baro_current_pas),2)
            if IFR1_BTN_ALT and not IFR1_LAST_BTN_ALT then
                ifr1_msg("sync baro")
                baro = baro_current
                ap_baro = baro
            else
                ifr1_msg(string.format("Baro: %0.2f, Current: %f", baro, baro_current))
            end
        end

        if IFR1_MODE == IFR1_MODE_VALUE_NAV1 then
            nav1_obs = ifr1_round((nav1_obs + k0 * 10 + k1),0) % 360
            ifr1_msg(string.format("NAV1 OBS: %d", nav1_obs))
        end

        if IFR1_MODE == IFR1_MODE_VALUE_NAV2 then
            nav2_obs = ifr1_round((nav2_obs + k0 * 10 + k1),0) % 360
            ifr1_msg(string.format("NAV2 OBS: %d", nav2_obs))
        end

        if IFR1_MODE == IFR1_MODE_VALUE_AP then
            if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
                command_once("sim/autopilot/back_course")
            end
        end
    else -- normal (not shift) mode
        if IFR1_MODE <= IFR1_MODE_VALUE_NAV2 then
            local freq_div = 5.0
            local freq = IFR1_MODE == IFR1_MODE_VALUE_COM1 and com1_sby or IFR1_MODE == IFR1_MODE_VALUE_COM2 and com2_sby or IFR1_MODE == IFR1_MODE_VALUE_NAV1 and nav1_sby or IFR1_MODE == IFR1_MODE_VALUE_NAV2 and nav2_sby or 0
            local khz = math.floor((freq % 100 + k1 * freq_div + freq_div/2)/freq_div)*freq_div  % 100
            local mhz = math.floor(freq/100) + k0
            if (IFR1_MODE == IFR1_MODE_VALUE_COM1 or IFR1_MODE == IFR1_MODE_VALUE_COM2) and mhz < 118 then
                mhz = 135
            end
            if (IFR1_MODE == IFR1_MODE_VALUE_COM1 or IFR1_MODE == IFR1_MODE_VALUE_COM2) and mhz > 135 then
                mhz = 118
            end

            if (IFR1_MODE == IFR1_MODE_VALUE_NAV1 or IFR1_MODE == IFR1_MODE_VALUE_NAV2) and mhz <108 then
                mhz = 117
            end
            if (IFR1_MODE == IFR1_MODE_VALUE_NAV1 or IFR1_MODE == IFR1_MODE_VALUE_NAV2) and mhz > 117 then
                mhz = 108
            end

            freq = mhz * 100 + khz
            if IFR1_MODE == IFR1_MODE_VALUE_COM1 then
                com1_sby = freq
                ifr1_msg(string.format("COM1: %0.3f", freq/100))
                if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                    com1_sby = com1_frq
                    com1_frq = freq
                end
            end
            if IFR1_MODE == IFR1_MODE_VALUE_COM2 then
                com2_sby = freq
                ifr1_msg(string.format("COM2: %0.3f", freq/100))
                if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                    com2_sby = com2_frq
                    com2_frq = freq
                end
            end
            if IFR1_MODE == IFR1_MODE_VALUE_NAV1 then
                nav1_sby = freq
                ifr1_msg(string.format("NAV1: %0.3f", freq/100))
                if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                    nav1_sby = nav1_frq
                    nav1_frq = freq
                end
            end
            if IFR1_MODE == IFR1_MODE_VALUE_NAV2 then
                nav2_sby = freq
                ifr1_msg(string.format("NAV2: %0.3f", freq/100))
                if IFR1_BTN_SWAP and not IFR1_LAST_BTN_SWAP then
                    nav2_sby = nav2_frq
                    nav2_frq = freq
                end
            end
        end

        if IFR1_MODE == IFR1_MODE_VALUE_FMS1 or IFR1_MODE == IFR1_MODE_VALUE_FMS2 then
            local fms_no = IFR1_MODE == IFR1_MODE_VALUE_FMS1 and 1 or 2

            if IFR1_BTN_DCT and not IFR1_LAST_BTN_DCT then
                command_once(string.format("sim/GPS/g430n%d_direct", fms_no))
            end

            if IFR1_BTN_MNU and not IFR1_LAST_BTN_MNU then
                command_once(string.format("sim/GPS/g430n%d_menu", fms_no))
            end

            if IFR1_BTN_CLR and not IFR1_LAST_BTN_CLR then
                command_once(string.format("sim/GPS/g430n%d_clr", fms_no))
            end

            if IFR1_BTN_ENT and not IFR1_LAST_BTN_ENT then
                command_once(string.format("sim/GPS/g430n%d_ent", fms_no))
            end

            if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
                command_once(string.format("sim/GPS/g430n%d_cdi", fms_no))
            end

            if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
                command_once(string.format("sim/GPS/g430n%d_obs", fms_no))
            end

            if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
                command_once(string.format("sim/GPS/g430n%d_msg", fms_no))
            end

            if IFR1_BTN_APR and not IFR1_LAST_BTN_APR then
                command_once(string.format("sim/GPS/g430n%d_fpl", fms_no))
            end

            if IFR1_BTN_ALT and not IFR1_LAST_BTN_ALT then
                command_once(string.format("sim/GPS/g430n%d_vnav", fms_no))
            end

            if IFR1_BTN_VS and not IFR1_LAST_BTN_VS then
                command_once(string.format("sim/GPS/g430n%d_proc", fms_no))
            end

            if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
                command_once(string.format("sim/GPS/g430n%d_cursor", fms_no))
            end

            for i = 1, math.abs(k1) do
                if k1 < 0 then
                    command_once(string.format("sim/GPS/g430n%d_page_dn", fms_no))
                else
                    command_once(string.format("sim/GPS/g430n%d_page_up", fms_no))
                end
            end

            for i = 1, math.abs(k0) do
                if k0 < 0 then
                    command_once(string.format("sim/GPS/g430n%d_chapter_dn", fms_no))
                else
                    command_once(string.format("sim/GPS/g430n%d_chapter_up", fms_no))
                end
            end
            
        end

        if IFR1_MODE == IFR1_MODE_VALUE_AP then
            local last_ap_vs = ap_vs
            local last_ap_alt = ap_alt
            ap_vs = math.floor(ap_vs/100 + k0 + 0.5) * 100
            ap_alt = math.floor(ap_alt/100 + k1 + 0.5) * 100

            if ap_vs ~= last_ap_vs or ap_alt ~= last_ap_alt then
                ifr1_msg(string.format("AP VS: %d, ALT: %d", ap_vs, ap_alt))
            end


            if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
                command_once("sim/autopilot/servos_toggle")
            end

            if IFR1_BTN_HDG and not IFR1_LAST_BTN_HDG then
                command_once("sim/autopilot/heading")
            end

            if IFR1_BTN_NAV and not IFR1_LAST_BTN_NAV then
                command_once("sim/autopilot/NAV")
            end

            if IFR1_BTN_APR and not IFR1_LAST_BTN_APR then
                command_once("sim/autopilot/approach")
            end

            if IFR1_BTN_ALT and IFR1_BTN_VS and not IFR1_LAST_BTN_ALT then
                command_once("sim/autopilot/alt_vs")
            else

                if IFR1_BTN_ALT and not IFR1_LAST_BTN_ALT then
                    command_once("sim/autopilot/altitude_hold")
                end

                if IFR1_BTN_VS and not IFR1_LAST_BTN_VS then
                    command_once("sim/autopilot/vertical_speed")

                end
            end
        end

        if IFR1_MODE == IFR1_MODE_VALUE_XPDR then
            if IFR1_BTN_KNOB and not IFR1_LAST_BTN_KNOB then
                xpdr_mode = (xpdr_mode + 1) % 4
            end
    
            local hund = math.floor(xpdr_code / 100)
            local ones = xpdr_code % 100
            hund = (hund + k0) % 78
            ones = (ones + k1) % 78
            xpdr_code = hund * 100 + ones
    
            if IFR1_BTN_AP and not IFR1_LAST_BTN_AP then
                command_once("sim/transponder/transponder_ident")
            end
        end
    end
end

function ifr1_send_leds(device)
    local led_val = 0
    if IFR1_MODE == IFR1_MODE_VALUE_AP then
        led_val = led_val + (IFR1_LED_AP and 2^0 or 0)
        led_val = led_val + (IFR1_LED_HDG and 2^1 or 0)
        led_val = led_val + (IFR1_LED_NAV and 2^2 or 0)
        led_val = led_val + (IFR1_LED_APR and 2^3 or 0)
        led_val = led_val + (IFR1_LED_ALT and 2^4 or 0)
        led_val = led_val + (IFR1_LED_VS and 2^5 or 0)
    end

    if IFR1_MODE == IFR1_MODE_VALUE_XPDR then
        led_val = led_val + (xpdr_ident > 0 and 2^0 or 0)
    end

    if IFR1_MODE_SHIFT then
        led_val = (sim_time - math.floor(sim_time)) < 0.1 and 0 or 0xff
    end

    if led_val ~= IFR1_LED_LAST_WRITE then
        hid_write(device, 11, led_val)
        IFR1_LED_LAST_WRITE = led_val
    end
end

function ifr1_draw()
    if IFR1_MSG_TIME + 5.0 > sim_time then
        draw_string_Helvetica_12(SCREEN_WIDTH - 700, SCREEN_HEIGHT - 50, IFR1_STATUS_TEXT)
    end
end

function ifr1_ubyte_to_sbyte(usb)
    if usb > 127 then
        return -256 + usb
    else
        return usb
    end
end

function ifr1_process()
    IFR1_LED_AP = ap_on > 0
    IFR1_LED_HDG = ap_lateral == 1 or ap_lateral == 14
    IFR1_LED_NAV = ap_lateral == 2 or ap_lateral == 13
    IFR1_LED_ALT = ap_vertical == 6
    IFR1_LED_VS = ap_vertical == 4
    IFR1_LED_APR = ap_appr > 0

    ifr1_open()
    if IFR1_DEVICE ~= nil then
        -- read from the IFR-1. Since it is set to non-blocking, this will return with nov == 0 if there is no report available
        local nov, byte0, buttons0, buttons1, buttons2, byte5, knob0, knob1, mode_val = hid_read(IFR1_DEVICE, 8)
        if (nov == 8) then
            knob0 = ifr1_ubyte_to_sbyte(knob0)
            knob1 = ifr1_ubyte_to_sbyte(knob1)
            ifr1_process_buttons_knobs(buttons0, buttons1, buttons2, knob0, knob1, mode_val)
        end
        ifr1_send_leds(IFR1_DEVICE)
    end
end

ifr1_open()
do_every_draw('ifr1_draw()')
do_every_frame('ifr1_process()')

-- INPUT (according to report, but read values don't match this format)
-- 32 bits (buttons)
-- 8 bits (knob 1)
-- 8 bits (knob 2)
-- 1 bits (?)
-- 1 bits (?)
-- 1 bits (?)
-- 5 bits (?)

-- OUTPUT
-- 8 bits (6 leds + 2 unused bits)

-- 0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
-- 0x09, 0x05,        // Usage (Game Pad)
-- 0xA1, 0x01,        // Collection (Application)
-- 0x85, 0x0B,        //   Report ID (11)
-- 0x05, 0x09,        //   Usage Page (Button)
-- 0x19, 0x01,        //   Usage Minimum (0x01)
-- 0x29, 0x20,        //   Usage Maximum (0x20)
-- 0x15, 0x00,        //   Logical Minimum (0)
-- 0x25, 0x01,        //   Logical Maximum (1)
-- 0x75, 0x01,        //   Report Size (1)
-- 0x95, 0x20,        //   Report Count (32)
-- 0x81, 0x02,        //   Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
-- 0x05, 0x01,        //   Usage Page (Generic Desktop Ctrls)
-- 0xA1, 0x02,        //   Collection (Logical)
-- 0x45, 0x00,        //     Physical Maximum (0)
-- 0x35, 0x00,        //     Physical Minimum (0)
-- 0x09, 0x37,        //     Usage (Dial)
-- 0x95, 0x02,        //     Report Count (2)
-- 0x75, 0x08,        //     Report Size (8)
-- 0x15, 0x81,        //     Logical Minimum (-127)
-- 0x25, 0x7F,        //     Logical Maximum (127)
-- 0x81, 0x06,        //     Input (Data,Var,Rel,No Wrap,Linear,Preferred State,No Null Position)
-- 0x05, 0x09,        //     Usage Page (Button)
-- 0x19, 0x01,        //     Usage Minimum (0x01)
-- 0x29, 0x03,        //     Usage Maximum (0x03)
-- 0x15, 0x00,        //     Logical Minimum (0)
-- 0x25, 0x01,        //     Logical Maximum (1)
-- 0x75, 0x01,        //     Report Size (1)
-- 0x95, 0x03,        //     Report Count (3)
-- 0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
-- 0x95, 0x01,        //     Report Count (1)
-- 0x75, 0x05,        //     Report Size (5)
-- 0x81, 0x03,        //     Input (Const,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
-- 0x05, 0x08,        //     Usage Page (LEDs)
-- 0x09, 0x2D,        //     Usage (Ready)
-- 0x15, 0x00,        //     Logical Minimum (0)
-- 0x25, 0x01,        //     Logical Maximum (1)
-- 0x95, 0x01,        //     Report Count (1)
-- 0x75, 0x08,        //     Report Size (8)
-- 0x91, 0x02,        //     Output (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position,Non-volatile)
-- 0xC0,              //   End Collection
-- 0xC0,              // End Collection

-- // 82 bytes

-- // best guess: USB HID Report Descriptor