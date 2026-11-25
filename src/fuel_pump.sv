`timescale 1ns / 1ps

// Secret fuel pump cut-off. The pump only gets power if the ignition is
// turned on first and then the hidden switch and brake are pressed together.
module fuel_pump (
    input  clk,
    input  rst,
    input  ignition,
    input  hidden_sw,
    input  brake,
    output pump_power
);

    localparam PUMP_OFF   = 2'd0,
               WAIT_COMBO = 2'd1,   // ignition on, waiting for hidden switch + brake
               PUMP_ON    = 2'd2;

    reg [1:0] state;

    wire combo = hidden_sw && brake;

    always @(posedge clk) begin
        if (rst || !ignition) begin
            state <= PUMP_OFF;
        end else begin
            case (state)
                // a combo already held before the key was turned doesn't count
                PUMP_OFF:   if (!combo) state <= WAIT_COMBO;
                WAIT_COMBO: if (combo)  state <= PUMP_ON;
                PUMP_ON:    state <= PUMP_ON;   // stays on until the ignition goes off
                default:    state <= PUMP_OFF;
            endcase
        end
    end

    assign pump_power = (state == PUMP_ON);

endmodule
