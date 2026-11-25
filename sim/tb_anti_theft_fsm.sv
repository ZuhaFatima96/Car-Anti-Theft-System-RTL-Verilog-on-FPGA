`timescale 1ns / 1ps

module tb_anti_theft_fsm;

    reg        clk = 0;
    reg        rst = 1;
    reg        ignition = 0;
    reg        driver_door = 0;
    reg        pass_door = 0;
    reg        reprogram = 0;
    reg        expired = 0;
    reg        one_hz_enable = 0;

    wire [1:0] interval;
    wire       start_timer;
    wire       status_led;
    wire       siren_on;
    wire [2:0] state;

    anti_theft_fsm dut (
        .clk(clk),
        .rst(rst),
        .ignition(ignition),
        .driver_door(driver_door),
        .pass_door(pass_door),
        .reprogram(reprogram),
        .expired(expired),
        .one_hz_enable(one_hz_enable),
        .interval(interval),
        .start_timer(start_timer),
        .status_led(status_led),
        .siren_on(siren_on),
        .state(state)
    );

    always #5 clk = ~clk;

    // stand-in for the 1 Hz tick, one pulse every 10 clocks
    always begin
        #90 one_hz_enable = 1;
        #10 one_hz_enable = 0;
    end

    // the timer isn't in this test, so 'expired' is pulsed by hand
    // whenever a countdown is supposed to finish
    initial begin
        #50 rst = 0;
        #400;                           // armed, LED blinking

        // owner turns the key
        ignition = 1;
        #200;

        // engine off, driver gets out, arm delay runs out
        ignition = 0;
        #100 driver_door = 1;
        #100 driver_door = 0;
        #200 expired = 1;
        #10  expired = 0;
        #400;

        // thief opens the driver door and has no key
        driver_door = 1;
        #200 expired = 1;               // countdown over, siren on
        #10  expired = 0;
        #200 driver_door = 0;           // siren keeps going for T_ALARM_ON
        #100 driver_door = 1;           // opened again
        #100 driver_door = 0;
        #200 expired = 1;               // back to armed
        #10  expired = 0;
        #400;

        // passenger door first, owner turns the key in time
        pass_door = 1;
        #200 driver_door = 1;
        #100 ignition = 1;
        #100;

        // both get out, guest reopens the door during the arm delay
        ignition = 0;
        #100 driver_door = 0;
        #100 pass_door = 0;             // arm delay starts
        #100 pass_door = 1;
        #100 pass_door = 0;             // arm delay starts over
        #200 expired = 1;
        #10  expired = 0;
        #300;

        // set off the alarm again and hit reprogram while it's sounding
        driver_door = 1;
        #200 expired = 1;
        #10  expired = 0;
        #100 driver_door = 0;
        #100 reprogram = 1;
        #10  reprogram = 0;
        #400;

        $finish;
    end

endmodule
