`timescale 1ns / 1ps

module tb_debounce;

    reg  clk   = 0;
    reg  rst   = 1;
    reg  noisy = 0;
    wire clean;

    // only 10 clocks of delay so the waveform is easy to read
    debounce #(.DELAY(10)) dut (
        .clk(clk),
        .rst(rst),
        .noisy(noisy),
        .clean(clean)
    );

    always #5 clk = ~clk;

    initial begin
        #50 rst = 0;

        // switch turned on, bounces a few times first
        #50 noisy = 1;
        #20 noisy = 0;
        #30 noisy = 1;
        #10 noisy = 0;
        #20 noisy = 1;
        #300;

        // switch turned off, also bouncy
        noisy = 0;
        #20 noisy = 1;
        #10 noisy = 0;
        #300;

        // short glitch, should never reach the output
        noisy = 1;
        #40 noisy = 0;
        #300;

        $finish;
    end

endmodule
