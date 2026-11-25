`timescale 1ns / 1ps

// Four 4-bit registers holding the delays in seconds.
module time_parameters (
    input        clk,
    input        rst,
    input        reprogram,
    input  [1:0] param_sel,
    input  [3:0] time_value,
    input  [1:0] interval,
    output [3:0] value
);

    reg [3:0] params [0:3];

    always @(posedge clk) begin
        if (rst) begin
            params[0] <= 4'd6;      // T_ARM_DELAY
            params[1] <= 4'd8;      // T_DRIVER_DELAY
            params[2] <= 4'd15;     // T_PASSENGER_DELAY
            params[3] <= 4'd10;     // T_ALARM_ON
        end else if (reprogram) begin
            params[param_sel] <= time_value;
        end
    end

    assign value = params[interval];

endmodule
