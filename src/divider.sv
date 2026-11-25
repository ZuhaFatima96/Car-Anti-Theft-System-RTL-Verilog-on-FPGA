`timescale 1ns / 1ps

// Turns the board clock into a one-cycle pulse every second.
module divider #(
    parameter CLK_FREQ = 100_000_000
)(
    input  clk,
    input  rst,
    output one_hz_enable
);

    reg [26:0] count;   // can count past 100 million

    always @(posedge clk) begin
        if (rst || one_hz_enable)
            count <= 0;
        else
            count <= count + 1;
    end

    assign one_hz_enable = (count == CLK_FREQ - 1);

endmodule
