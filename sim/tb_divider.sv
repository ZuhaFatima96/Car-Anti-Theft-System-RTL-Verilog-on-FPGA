`timescale 1ns / 1ps

module tb_divider;

    reg  clk = 0;
    reg  rst = 1;
    wire one_hz_enable;

    // pretend one second is 10 clocks
    divider #(.CLK_FREQ(10)) dut (
        .clk(clk),
        .rst(rst),
        .one_hz_enable(one_hz_enable)
    );

    always #5 clk = ~clk;

    initial begin
        #20 rst = 0;
        #530;

        // restart in the middle of a count, next pulse should be 10 clocks later
        rst = 1;
        #10 rst = 0;
        #300;

        $finish;
    end

endmodule
