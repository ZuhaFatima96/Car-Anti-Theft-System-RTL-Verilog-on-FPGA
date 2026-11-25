`timescale 1ns / 1ps

module tb_anti_theft_top;

    reg        clk = 0;
    reg        btn_reset = 1;
    reg        btn_reprogram = 0;
    reg        sw_ignition = 0;
    reg        sw_driver_door = 0;
    reg        sw_pass_door = 0;
    reg        sw_hidden = 0;
    reg        sw_brake = 0;
    reg  [1:0] sw_param_sel = 0;
    reg  [3:0] sw_time_value = 0;

    wire       led_status;
    wire       led_siren;
    wire       led_fuel_pump;
    wire [2:0] led_state;
    wire       speaker;

    // One "second" is only 100 clocks here, so 1 us on the waveform
    // is 1 s in the real car and the whole run takes about 100 us.
    localparam SEC = 1000;

    anti_theft_top #(
        .CLK_FREQ(100),
        .DB_DELAY(5),
        .TONE_HALF(5)
    ) dut (
        .clk(clk),
        .btn_reset(btn_reset),
        .btn_reprogram(btn_reprogram),
        .sw_ignition(sw_ignition),
        .sw_driver_door(sw_driver_door),
        .sw_pass_door(sw_pass_door),
        .sw_hidden(sw_hidden),
        .sw_brake(sw_brake),
        .sw_param_sel(sw_param_sel),
        .sw_time_value(sw_time_value),
        .led_status(led_status),
        .led_siren(led_siren),
        .led_fuel_pump(led_fuel_pump),
        .led_state(led_state),
        .speaker(speaker)
    );

    always #5 clk = ~clk;

    initial begin
        #100 btn_reset = 0;
        #(3*SEC);                               // powered on: armed, LED blinking

        // owner opens the driver door and turns the key within 8 s
        sw_driver_door = 1;
        #(3*SEC) sw_ignition = 1;               // disarmed
        #(1*SEC) sw_driver_door = 0;

        // secret combo turns the fuel pump on
        #(2*SEC) sw_hidden = 1; sw_brake = 1;
        #(1*SEC) sw_hidden = 0; sw_brake = 0;

        // parks and gets out, alarm arms 6 s after the door shuts
        #(3*SEC) sw_ignition = 0;               // pump off
        #(1*SEC) sw_driver_door = 1;
        #(1*SEC) sw_driver_door = 0;
        #(9*SEC);

        // thief opens the door with no key: siren after 8 s
        sw_driver_door = 1;
        #(11*SEC) sw_driver_door = 0;           // siren stays on 10 s more
        #(13*SEC);

        // thief hot-wires it: alarm disarms but the fuel pump stays off
        sw_ignition = 1;
        #(2*SEC) sw_brake = 1;
        #(1*SEC) sw_brake = 0;
        #(2*SEC) sw_ignition = 0;
        #(1*SEC) sw_driver_door = 1;
        #(1*SEC) sw_driver_door = 0;            // arms again 6 s later
        #(9*SEC);

        // owner with a guest: passenger door first gives her 15 s
        sw_pass_door = 1;
        #(5*SEC) sw_driver_door = 1;
        #(2*SEC) sw_ignition = 1;               // disarmed in time
        #(1*SEC) sw_pass_door = 0; sw_driver_door = 0;

        // both get out, guest reopens the door during the arm delay
        #(3*SEC) sw_ignition = 0;
        #(1*SEC) sw_driver_door = 1; sw_pass_door = 1;
        #(1*SEC) sw_driver_door = 0;
        #(2*SEC) sw_pass_door = 0;              // arm delay starts
        #(3*SEC) sw_pass_door = 1;
        #(1*SEC) sw_pass_door = 0;              // arm delay starts over
        #(8*SEC);

        // reprogram T_DRIVER_DELAY (01) to 2 s
        sw_param_sel = 2'b01; sw_time_value = 4'd2;
        #(1*SEC) btn_reprogram = 1;
        #(SEC/5) btn_reprogram = 0;
        #(2*SEC);

        // driver door again, siren after only 2 s, owner's key stops it
        sw_driver_door = 1;
        #(4*SEC) sw_ignition = 1;
        #(1*SEC) sw_driver_door = 0;
        #(2*SEC);

        $finish;
    end

endmodule
