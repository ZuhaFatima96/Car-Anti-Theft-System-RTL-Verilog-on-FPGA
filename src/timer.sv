`timescale 1ns / 1ps

// Loads 'value' when start_timer is high, counts it down once a second
// and holds expired high once it hits zero.
module timer #(
    parameter CLK_FREQ = 100_000_000
)(
    input        clk,
    input        rst,
    input        start_timer,
    input  [3:0] value,
    output       expired,
    output       one_hz_enable
);

    reg [3:0] count;

    // restart the divider on every start so the first tick is a full second away
    divider #(.CLK_FREQ(CLK_FREQ)) div (
        .clk(clk),
        .rst(rst || start_timer),
        .one_hz_enable(one_hz_enable)
    );

    always @(posedge clk) begin
        if (rst)
            count <= 0;
        else if (start_timer)
            count <= value;
        else if (one_hz_enable && count != 0)
            count <= count - 1;
    end

    assign expired = (count == 0);

endmodule
