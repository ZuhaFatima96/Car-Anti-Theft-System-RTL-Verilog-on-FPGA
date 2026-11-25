`timescale 1ns / 1ps

// Waits for a switch to stay still for DELAY clock cycles before
// letting the new value through.
module debounce #(
    parameter DELAY = 1_000_000,    // 10 ms at 100 MHz
    parameter WIDTH = 1
)(
    input                  clk,
    input                  rst,
    input      [WIDTH-1:0] noisy,
    output reg [WIDTH-1:0] clean
);

    reg [WIDTH-1:0] sync_0, sync_1;
    reg [WIDTH-1:0] last;
    reg [19:0]      count;          // big enough for 10 ms at 100 MHz

    // two flip-flops first so the switch is synchronized to our clock
    always @(posedge clk) begin
        sync_0 <= noisy;
        sync_1 <= sync_0;
    end

    always @(posedge clk) begin
        if (rst) begin
            last  <= 0;
            clean <= 0;
            count <= 0;
        end else if (sync_1 != last) begin
            last  <= sync_1;        // input moved, start counting again
            count <= 0;
        end else if (count == DELAY) begin
            clean <= last;
        end else begin
            count <= count + 1;
        end
    end

endmodule
