`timescale 1ns / 1ps

module anti_theft_top #(
    parameter CLK_FREQ  = 100_000_000,  // board clock
    parameter DB_DELAY  = 1_000_000,    // 10 ms debounce
    parameter TONE_HALF = 50_000        // 1 kHz siren tone
)(
    input        clk,
    input        btn_reset,
    input        btn_reprogram,
    input        sw_ignition,
    input        sw_driver_door,
    input        sw_pass_door,
    input        sw_hidden,
    input        sw_brake,
    input  [1:0] sw_param_sel,
    input  [3:0] sw_time_value,
    output       led_status,
    output       led_siren,
    output       led_fuel_pump,
    output [2:0] led_state,
    output       speaker
);

    // reset button synced to the clock. It starts at 1 so everything also
    // resets itself right after the board is programmed.
    reg [1:0] rst_sync = 2'b11;
    always @(posedge clk)
        rst_sync <= {rst_sync[0], btn_reset};
    wire rst = rst_sync[1];

    wire       ignition, driver_door, pass_door, hidden_sw, brake, reprogram;
    wire [1:0] param_sel;
    wire [3:0] time_value;

    debounce #(.DELAY(DB_DELAY)) db_ignition  (.clk(clk), .rst(rst), .noisy(sw_ignition),    .clean(ignition));
    debounce #(.DELAY(DB_DELAY)) db_driver    (.clk(clk), .rst(rst), .noisy(sw_driver_door), .clean(driver_door));
    debounce #(.DELAY(DB_DELAY)) db_passenger (.clk(clk), .rst(rst), .noisy(sw_pass_door),   .clean(pass_door));
    debounce #(.DELAY(DB_DELAY)) db_hidden    (.clk(clk), .rst(rst), .noisy(sw_hidden),      .clean(hidden_sw));
    debounce #(.DELAY(DB_DELAY)) db_brake     (.clk(clk), .rst(rst), .noisy(sw_brake),       .clean(brake));
    debounce #(.DELAY(DB_DELAY)) db_reprogram (.clk(clk), .rst(rst), .noisy(btn_reprogram),  .clean(reprogram));

    // selector and value switches share one 6-bit debouncer
    debounce #(.DELAY(DB_DELAY), .WIDTH(6)) db_settings (
        .clk(clk),
        .rst(rst),
        .noisy({sw_param_sel, sw_time_value}),
        .clean({param_sel, time_value})
    );

    wire [1:0] interval;
    wire [3:0] value;
    wire       start_timer, expired, one_hz_enable;
    wire       siren_on;

    time_parameters params (
        .clk(clk),
        .rst(rst),
        .reprogram(reprogram),
        .param_sel(param_sel),
        .time_value(time_value),
        .interval(interval),
        .value(value)
    );

    timer #(.CLK_FREQ(CLK_FREQ)) timer_1hz (
        .clk(clk),
        .rst(rst),
        .start_timer(start_timer),
        .value(value),
        .expired(expired),
        .one_hz_enable(one_hz_enable)
    );

    anti_theft_fsm fsm (
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
        .status_led(led_status),
        .siren_on(siren_on),
        .state(led_state)
    );

    fuel_pump pump (
        .clk(clk),
        .rst(rst),
        .ignition(ignition),
        .hidden_sw(hidden_sw),
        .brake(brake),
        .pump_power(led_fuel_pump)
    );

    siren #(.TONE_HALF(TONE_HALF)) siren_gen (
        .clk(clk),
        .rst(rst),
        .siren_on(siren_on),
        .siren_led(led_siren),
        .speaker(speaker)
    );

endmodule
