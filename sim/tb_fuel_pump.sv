`timescale 1ns / 1ps

module tb_fuel_pump;

    reg  clk = 0;
    reg  rst = 1;
    reg  ignition = 0;
    reg  hidden_sw = 0;
    reg  brake = 0;
    wire pump_power;

    fuel_pump dut (
        .clk(clk),
        .rst(rst),
        .ignition(ignition),
        .hidden_sw(hidden_sw),
        .brake(brake),
        .pump_power(pump_power)
    );

    always #5 clk = ~clk;

    initial begin
        #50 rst = 0;

        // owner: key first, then hidden switch + brake
        #50  ignition = 1;
        #50  hidden_sw = 1;
        #50  brake = 1;                 // pump turns on
        #50  hidden_sw = 0;
        brake = 0;                      // stays on after letting go
        #200 ignition = 0;              // key off cuts it
        #100;

        // thief: ignition on, presses the brake, doesn't know the switch
        ignition = 1;
        #50  brake = 1;
        #100 brake = 0;
        #100 ignition = 0;
        #100;

        // combo held before the key turns: has to be pressed again
        hidden_sw = 1;
        brake = 1;
        #50  ignition = 1;              // still off
        #100 hidden_sw = 0;
        brake = 0;
        #50  hidden_sw = 1;
        brake = 1;                      // now it turns on
        #100 ignition = 0;
        hidden_sw = 0;
        brake = 0;
        #100;

        $finish;
    end

endmodule
