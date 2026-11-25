`timescale 1ns / 1ps

module anti_theft_fsm (
    input            clk,
    input            rst,
    input            ignition,
    input            driver_door,
    input            pass_door,
    input            reprogram,
    input            expired,
    input            one_hz_enable,
    output reg [1:0] interval,
    output reg       start_timer,
    output reg       status_led,
    output           siren_on,
    output reg [2:0] state
);

    localparam ARMED      = 3'd0,
               TRIGGERED  = 3'd1,   // countdown running, waiting for the key
               ALARM      = 3'd2,   // siren on, a door is still open
               ALARM_HOLD = 3'd3,   // doors closed, siren keeps going for T_ALARM_ON
               DISARMED   = 3'd4,   // ignition is on
               WAIT_DOOR  = 3'd5,   // ignition off, waiting for the driver to get out
               WAIT_CLOSE = 3'd6,   // waiting for every door to be shut
               ARM_DELAY  = 3'd7;   // all shut, counting T_ARM_DELAY

    // parameter numbers from the timing table
    localparam T_ARM       = 2'b00,
               T_DRIVER    = 2'b01,
               T_PASSENGER = 2'b10,
               T_ALARM_ON  = 2'b11;

    reg [2:0] next_state;
    reg       blink;

    wire door_open = driver_door || pass_door;

    always @(posedge clk) begin
        if (rst || reprogram)
            state <= ARMED;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state  = state;
        start_timer = 1'b0;
        interval    = T_ARM;

        case (state)
            ARMED: begin
                if (ignition) begin
                    next_state = DISARMED;
                end else if (driver_door) begin
                    interval    = T_DRIVER;
                    start_timer = 1'b1;
                    next_state  = TRIGGERED;
                end else if (pass_door) begin
                    interval    = T_PASSENGER;
                    start_timer = 1'b1;
                    next_state  = TRIGGERED;
                end
            end

            TRIGGERED: begin
                if (ignition)
                    next_state = DISARMED;
                else if (expired)
                    next_state = ALARM;
            end

            ALARM: begin
                if (ignition) begin
                    next_state = DISARMED;
                end else if (!door_open) begin
                    interval    = T_ALARM_ON;
                    start_timer = 1'b1;
                    next_state  = ALARM_HOLD;
                end
            end

            ALARM_HOLD: begin
                if (ignition)
                    next_state = DISARMED;
                else if (door_open)
                    next_state = ALARM;         // opened again, wait for it to close
                else if (expired)
                    next_state = ARMED;
            end

            DISARMED: begin
                if (!ignition)
                    next_state = WAIT_DOOR;
            end

            WAIT_DOOR: begin
                if (ignition)
                    next_state = DISARMED;
                else if (driver_door)
                    next_state = WAIT_CLOSE;
            end

            WAIT_CLOSE: begin
                if (ignition) begin
                    next_state = DISARMED;
                end else if (!door_open) begin
                    interval    = T_ARM;
                    start_timer = 1'b1;
                    next_state  = ARM_DELAY;
                end
            end

            ARM_DELAY: begin
                if (ignition)
                    next_state = DISARMED;
                else if (door_open)
                    next_state = WAIT_CLOSE;    // delay starts over once it's shut again
                else if (expired)
                    next_state = ARMED;
            end

            default: next_state = ARMED;
        endcase
    end

    // flips once a second, so the LED blinks with a 2 second period
    always @(posedge clk) begin
        if (rst)
            blink <= 1'b0;
        else if (one_hz_enable)
            blink <= ~blink;
    end

    always @(*) begin
        case (state)
            ARMED:                        status_led = blink;
            TRIGGERED, ALARM, ALARM_HOLD: status_led = 1'b1;
            default:                      status_led = 1'b0;
        endcase
    end

    assign siren_on = (state == ALARM) || (state == ALARM_HOLD);

endmodule
