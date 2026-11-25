`timescale 1ns / 1ps

module tb_timer;

    reg        clk = 0;
    reg        rst = 1;
    reg        start_timer = 0;
    reg  [3:0] value = 0;
    wire       expired;
    wire       one_hz_enable;

    // one second = 10 clocks = 100 ns
    timer #(.CLK_FREQ(10)) dut (
        .clk(clk),
        .rst(rst),
        .start_timer(start_timer),
        .value(value),
        .expired(expired),
        .one_hz_enable(one_hz_enable)
    );

    always #5 clk = ~clk;

    initial begin
        #20 rst = 0;

        // 3 second countdown
        #20 value = 4'd3;
        start_timer = 1;
        #10 start_timer = 0;
        #500;

        // 5 seconds, restarted halfway through
        value = 4'd5;
        start_timer = 1;
        #10 start_timer = 0;
        #250;
        start_timer = 1;
        #10 start_timer = 0;
        #700;

        // long count, then a start with 0 in the middle: expires straight away
        value = 4'd9;
        start_timer = 1;
        #10 start_timer = 0;
        #250 value = 4'd0;
        start_timer = 1;
        #10 start_timer = 0;
        #200;

        $finish;
    end

endmodule
