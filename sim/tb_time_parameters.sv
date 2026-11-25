`timescale 1ns / 1ps

module tb_time_parameters;

    reg        clk = 0;
    reg        rst = 1;
    reg        reprogram = 0;
    reg  [1:0] param_sel = 0;
    reg  [3:0] time_value = 0;
    reg  [1:0] interval = 0;
    wire [3:0] value;

    time_parameters dut (
        .clk(clk),
        .rst(rst),
        .reprogram(reprogram),
        .param_sel(param_sel),
        .time_value(time_value),
        .interval(interval),
        .value(value)
    );

    always #5 clk = ~clk;

    initial begin
        #20 rst = 0;

        // read the defaults: 6, 8, 15, 10
        #20 interval = 2'd0;
        #20 interval = 2'd1;
        #20 interval = 2'd2;
        #20 interval = 2'd3;

        // set the driver delay to 3 s
        #20 param_sel = 2'd1;
        time_value = 4'd3;
        #20 reprogram = 1;
        #10 reprogram = 0;

        // set the siren time to 0 s
        #20 param_sel = 2'd3;
        time_value = 4'd0;
        #20 reprogram = 1;
        #10 reprogram = 0;

        // read everything again: 6, 3, 15, 0
        #20 interval = 2'd0;
        #20 interval = 2'd1;
        #20 interval = 2'd2;
        #20 interval = 2'd3;

        // reset brings the defaults back
        #20 rst = 1;
        #20 rst = 0;
        #20 interval = 2'd1;
        #40;

        $finish;
    end

endmodule
