mode = 0
last_mode = 0
dev_status = ""

knob0_position = 0
knob1_position = 0

led_ap = false
led_hdg = false
led_nav = false
led_apr = false
led_alt = false
led_vs = false

last_btn_knob = false
last_btn_swap = false
last_btn_ap = false
last_btn_hdg = false
last_btn_nav = false
last_btn_apr = false
last_btn_alt = false
last_btn_vs = false
last_btn_dct = false
last_btn_mnu = false
last_btn_clr = false
last_btn_ent = false

btn_knob = false
btn_swap = false
btn_ap = false
btn_hdg = false
btn_nav = false
btn_apr = false
btn_alt = false
btn_vs = false
btn_dct = false
btn_mnu = false
btn_clr = false
btn_ent = false

mode_shft = false

MODEVAL_COM1 = 0
MODEVAL_COM2 = 1
MODEVAL_NAV1 = 2
MODEVAL_NAV2 = 3
MODEVAL_FMS1 = 4
MODEVAL_FMS2 = 5
MODEVAL_AP   = 6
MODEVAL_XPDR = 7

AP_HDG  = 0x00002
AP_NAVA = 0x00100
AP_NAVE = 0x00200
AP_APR  = 0x00400


led_last_write = 0xff

DataRef("ap_on", "sim/cockpit2/autopilot/servos_on")
DataRef("ap_lateral", "sim/cockpit2/autopilot/heading_mode")
DataRef("ap_vertical", "sim/cockpit2/autopilot/altitude_mode")
DataRef("ap_appr", "sim/cockpit2/autopilot/approach_status")
DataRef("ap_vs", "sim/cockpit2/autopilot/vvi_dial_fpm", "writable")
DataRef("ap_alt", "sim/cockpit2/autopilot/altitude_dial_ft", "writable")
DataRef("xpdr_code", "sim/cockpit2/radios/actuators/transponder_code", "writable")
DataRef("nav1_obs", "sim/cockpit/radios/nav1_obs_degm", "writable")
DataRef("nav2_obs", "sim/cockpit/radios/nav2_obs_degm", "writable")
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
DataRef("xpdr_ident", "sim/cockpit2/radios/indicators/transponder_id")
-- DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
-- DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
-- DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
-- DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
-- DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
DataRef("ap_state", "sim/cockpit/autopilot/autopilot_state")
DataRef("heading", "sim/cockpit/autopilot/heading_mag", "writable")

device = hid_open(0x4d8,0xe6d6)
hid_set_nonblocking(device, 1)
-- hid_send_filled_feature_report(device, 11, 8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff )
hid_write(device, 11, led_last_write)

function bitfield_if(val, bv, cond)
    return bit.bor(bit.band(val, bit.bnot(bv)), (cond and bv or 0))
end

function bit_if(val, b, cond)
    local bv = bit.lshift(1, b)
    return bitfield_if(val, bv, cond)
end

function pascalsToInchesMercury(pascals)
    local inchesMercury = pascals * 0.0002953
    return inchesMercury
end

function roundToDecimalPlaces(num, numDecimalPlaces)
    local mult = 10 ^ numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
end

function clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end


function msg(str)
    dev_status = "IFR-1: " .. str
    print(dev_status)
end



function ifr1_last_buttons()
    btn_knob = last_btn_knob
    btn_swap = last_btn_swap
    btn_ap = last_btn_ap
    btn_hdg = last_btn_hdg
    btn_nav = last_btn_nav
    btn_apr = last_btn_apr
    btn_alt = last_btn_alt
    btn_vs = last_btn_vs
    btn_dct = last_btn_dct
    btn_mnu = last_btn_mnu
    btn_clr = last_btn_clr
    btn_ent = last_btn_ent
    last_mode = mode
end

function ifr1_process_buttons_knobs(b0, b1, b2, k0, k1, mv)
    ifr1_last_buttons()
    mode = mv
    btn_knob = bit.band(b1, 0x02) > 0
    btn_swap = bit.band(b1, 0x01) > 0
    btn_ap =   bit.band(b1, 0x40) > 0
    btn_hdg =  bit.band(b1, 0x80) > 0
    btn_nav =  bit.band(b2, 0x01) > 0
    btn_apr =  bit.band(b2, 0x02) > 0
    btn_alt =  bit.band(b2, 0x04) > 0
    btn_vs =   bit.band(b2, 0x08) > 0
    btn_dct =  bit.band(b0, 0x10) > 0
    btn_mnu =  bit.band(b0, 0x20) > 0
    btn_clr =  bit.band(b0, 0x40) > 0
    btn_ent =  bit.band(b0, 0x80) > 0

    if btn_knob and not last_btn_knob then
        mode_shft = not mode_shft
    end

    if mode >= MODEVAL_XPDR or mode == MODEVAL_FMS1 or mode == MODEVAL_FMS2 or mode ~= last_mode then
        mode_shft = false
    end

    if mode_shft then
        if mode == MODEVAL_COM1 then
            heading = roundToDecimalPlaces((heading + k0 * 10 + k1),0) % 360

            if btn_hdg and not last_btn_hdg then
                msg("sync DG")
                command_once("sim/instruments/DG_sync_mag")
            else
                msg(string.format("Heading bug: %d, indicated: %d, dg: %d", heading, heading_indicated, dg_heading))
            end

        end

        if mode == MODEVAL_COM2 then
            baro = roundToDecimalPlaces(baro + k0 / 10.0 + k1 / 100.0, 2)
            local baro_current = roundToDecimalPlaces(pascalsToInchesMercury(baro_current_pas),2)
            if btn_alt and not last_btn_alt then
                msg("sync baro")
                baro = baro_current
                ap_baro = baro
            else
                msg(string.format("Baro: %0.2f, Current: %f", baro, baro_current))
            end
        end

        if mode == MODEVAL_NAV1 then
            nav1_obs = roundToDecimalPlaces((nav1_obs + k0 * 10 + k1),0) % 360
            msg(string.format("NAV1 OBS: %d", nav1_obs))
        end

        if mode == MODEVAL_NAV2 then
            nav2_obs = roundToDecimalPlaces((nav2_obs + k0 * 10 + k1),0) % 360
            msg(string.format("NAV2 OBS: %d", nav2_obs))
        end
    else
        if mode <= MODEVAL_NAV2 then
            local freq_div = 5.0
            local freq = mode == MODEVAL_COM1 and com1_sby or mode == MODEVAL_COM2 and com2_sby or mode == MODEVAL_NAV1 and nav1_sby or mode == MODEVAL_NAV2 and nav2_sby or 0
            local khz = math.floor((freq % 100 + k1 * freq_div + freq_div/2)/freq_div)*freq_div  % 100
            local mhz = math.floor(freq/100) + k0
            if (mode == MODEVAL_COM1 or mode == MODEVAL_COM2) and mhz < 118 then
                mhz = 135
            end
            if (mode == MODEVAL_COM1 or mode == MODEVAL_COM2) and mhz > 135 then
                mhz = 118
            end

            if (mode == MODEVAL_NAV1 or mode == MODEVAL_NAV2) and mhz <108 then
                mhz = 117
            end
            if (mode == MODEVAL_NAV1 or mode == MODEVAL_NAV2) and mhz > 117 then
                mhz = 108
            end

            freq = mhz * 100 + khz
            if mode == MODEVAL_COM1 then
                com1_sby = freq
                msg(string.format("COM1: %0.3f", freq/100))
                if btn_swap and not last_btn_swap then
                    com1_sby = com1_frq
                    com1_frq = freq
                end
            end
            if mode == MODEVAL_COM2 then
                com2_sby = freq
                msg(string.format("COM2: %0.3f", freq/100))
                if btn_swap and not last_btn_swap then
                    com2_sby = com2_frq
                    com2_frq = freq
                end
            end
            if mode == MODEVAL_NAV1 then
                nav1_sby = freq
                msg(string.format("NAV1: %0.3f", freq/100))
                if btn_swap and not last_btn_swap then
                    nav1_sby = nav1_frq
                    nav1_frq = freq
                end
            end
            if mode == MODEVAL_NAV2 then
                nav2_sby = freq
                msg(string.format("NAV2: %0.3f", freq/100))
                if btn_swap and not last_btn_swap then
                    nav2_sby = nav2_frq
                    nav2_frq = freq
                end
            end
        end

        if mode == MODEVAL_FMS1 or mode == MODEVAL_FMS2 then
            local fms_no = mode == MODEVAL_FMS1 and 1 or 2

            if btn_dct and not last_btn_dct then
                command_once(string.format("sim/GPS/g430n%d_direct", fms_no))
            end

            if btn_mnu and not last_btn_mnu then
                command_once(string.format("sim/GPS/g430n%d_menu", fms_no))
            end

            if btn_clr and not last_btn_clr then
                command_once(string.format("sim/GPS/g430n%d_clr", fms_no))
            end

            if btn_ent and not last_btn_ent then
                command_once(string.format("sim/GPS/g430n%d_ent", fms_no))
            end

            if btn_ap and not last_btn_ap then
                command_once(string.format("sim/GPS/g430n%d_cdi", fms_no))
            end

            if btn_hdg and not last_btn_hdg then
                command_once(string.format("sim/GPS/g430n%d_obs", fms_no))
            end

            if btn_nav and not last_btn_nav then
                command_once(string.format("sim/GPS/g430n%d_msg", fms_no))
            end

            if btn_apr and not last_btn_apr then
                command_once(string.format("sim/GPS/g430n%d_fpl", fms_no))
            end

            if btn_alt and not last_btn_alt then
                command_once(string.format("sim/GPS/g430n%d_vnav", fms_no))
            end

            if btn_vs and not last_btn_vs then
                command_once(string.format("sim/GPS/g430n%d_proc", fms_no))
            end

            if btn_knob and not last_btn_knob then
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

    end

    if mode == MODEVAL_AP then
        if not mode_shft then
            local last_ap_vs = ap_vs
            local last_ap_alt = ap_alt
            ap_vs = math.floor(ap_vs/100 + k0 + 0.5) * 100
            ap_alt = math.floor(ap_alt/100 + k1 + 0.5) * 100

            if ap_vs ~= last_ap_vs or ap_alt ~= last_ap_alt then
                msg(string.format("AP VS: %d, ALT: %d", ap_vs, ap_alt))
            end


            if btn_ap and not last_btn_ap then
                -- XPLMSpeakString( "disconnect" )
                command_once("sim/autopilot/servos_toggle")
            end

            if btn_hdg and not last_btn_hdg then
                command_once("sim/autopilot/heading")
            end

            if btn_nav and not last_btn_nav then
                command_once("sim/autopilot/NAV")
            end

            if btn_apr and not last_btn_apr then
                command_once("sim/autopilot/approach")
            end

            if btn_alt and btn_vs and not last_btn_alt then
                command_once("sim/autopilot/alt_vs")
            else

                if btn_alt and not last_btn_alt then
                    command_once("sim/autopilot/altitude_hold")
                    -- command_once("sim/autopilot/alt_vs")
                end

                if btn_vs and not last_btn_vs then
                    ap_vs = 0
                    command_once("sim/autopilot/vertical_speed")
                    -- command_once("sim/autopilot/alt_vs")

                end
            end
        else
            if btn_nav and not last_btn_nav then
                command_once("sim/autopilot/back_course")
            end
        end
    end

    if mode == MODEVAL_XPDR then
        if btn_knob and not last_btn_knob then
            xpdr_mode = (xpdr_mode + 1) % 4
        end

        local hund = math.floor(xpdr_code / 100)
        local ones = xpdr_code % 100
        hund = (hund + k0) % 78
        ones = (ones + k1) % 78
        xpdr_code = hund * 100 + ones

        if btn_ap and not last_btn_ap then
            command_once("sim/transponder/transponder_ident")
        end
    end
end

function ifr1_send_leds(device)
    local led_val = 0
    if mode == MODEVAL_AP then
        led_val = led_val + (led_ap and 2^0 or 0)
        led_val = led_val + (led_hdg and 2^1 or 0)
        led_val = led_val + (led_nav and 2^2 or 0)
        led_val = led_val + (led_apr and 2^3 or 0)
        led_val = led_val + (led_alt and 2^4 or 0)
        led_val = led_val + (led_vs and 2^5 or 0)
    end

    if mode == MODEVAL_XPDR then
        led_val = led_val + (xpdr_ident and 2^0 or 0)
    end

    if mode_shft then
        led_val = 0xff
    end

    if led_val ~= led_last_write then
        hid_write(device, 11, led_val)
        led_last_write = led_val
    end
end

function ifr1_split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function ifr1_draw()

    -- dev_detail = ""
    -- local ds = dev_status
    -- local split_ds = ifr1_split(ds, "\n")
    -- for i, item in ipairs(split_ds) do
    --     draw_string_Times_Roman_24(SCREEN_WIDTH - 700, SCREEN_HEIGHT - 50 * i, item)
    -- end
    draw_string_Helvetica_12(SCREEN_WIDTH - 700, SCREEN_HEIGHT - 50, dev_status)

    -- draw_string_Times_Roman_24(SCREEN_WIDTH - 700, SCREEN_HEIGHT - 30, "IFR-1 knobs " .. string.format("%d %d %d", knob0_position, knob1_position, mode))
	
end

function signed_byte(usb)
    if usb > 127 then
        return -256 + usb
    else
        return usb
    end
end

function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

function ifr1_process()
    led_ap = ap_on --ap_state > 0
    led_hdg = ap_lateral == 1 or ap_lateral == 14
    led_nav = ap_lateral == 2 or ap_lateral == 13
    led_alt = ap_vertical == 6
    led_vs = ap_vertical == 4
    led_apr = ap_appr > 0

    if(device == nil) then
        dev_status = "Not found"
    else
        local nov, buttons0, buttons1, buttons2, buttons3, spare, knob0, knob1, mv = hid_read(device, 8)
        -- local novr, report_id, buttons0, buttons1, buttons2, buttons3, knob0, knob1, spare = hid_get_feature_report(device, 7)
        if (nov == 8) then
            knob0 = signed_byte(knob0)
            knob1 = signed_byte(knob1)
            knob0_position = knob0_position + knob0
            knob1_position = knob1_position + knob1
            ifr1_process_buttons_knobs(buttons1, buttons2, buttons3, knob0, knob1, mv)
            -- dev_detail = string.format("%02x %02x %02x %02x %02x %d %d %02x", buttons0, buttons1, buttons2, buttons3, spare, knob0, knob1, mv)

        end
        -- dev_status = dev_detail
        ifr1_send_leds(device)
        --string.format(" %02x %02x %02x %02x %02x %02x %02x %02x", b0 or 0, b1 or 0, b2 or 0, b3 or 0, b4 or 0, b5 or 0, b6 or 0, b7 or 0)
    end
end

do_every_draw('ifr1_draw()')
do_every_frame('ifr1_process()')

-- INPUT
-- 32 bits (buttons)
-- 8 bits (knob 1)
-- 8 bits (knob 2)
-- 1 bits (?)
-- 1 bits (?)
-- 1 bits (?)
-- 5 bits (?)

-- OUTPUT
-- 8 bits (leds)

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