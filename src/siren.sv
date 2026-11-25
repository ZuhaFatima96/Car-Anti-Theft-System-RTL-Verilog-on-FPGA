`timescale 1ns / 1ps

// Keeps the siren LED on while the alarm is going and makes a square
// wave tone for an external speaker.
module siren #(
    parameter TONE_HALF = 50_000    // clocks per half wave, 1 kHz at 100 MHz
)(
    input      clk,
    input      rst,
    input      siren_on,
    output     siren_led,
    output reg speaker
);

    reg [15:0] count;

    always @(posedge clk) begin
        if (rst || !siren_on) begin
            count   <= 0;
            speaker <= 1'b0;
        end else if (count == TONE_HALF - 1) begin
            count   <= 0;
            speaker <= ~speaker;
        end else begin
            count <= count + 1;
        end
    end

    assign siren_led = siren_on;

endmodule
