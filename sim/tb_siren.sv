`timescale 1ns / 1ps

module tb_siren;

    reg  clk = 0;
    reg  rst = 1;
    reg  siren_on = 0;
    wire siren_led;
    wire speaker;

    // 4 clocks per half wave so the tone is visible in the waveform
    siren #(.TONE_HALF(4)) dut (
        .clk(clk),
        .rst(rst),
        .siren_on(siren_on),
        .siren_led(siren_led),
        .speaker(speaker)
    );

    always #5 clk = ~clk;

    initial begin
        #50  rst = 0;
        #100 siren_on = 1;
        #500 siren_on = 0;
        #200 siren_on = 1;
        #300 siren_on = 0;
        #100;

        $finish;
    end

endmodule
