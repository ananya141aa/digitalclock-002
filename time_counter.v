`timescale 1ns/1ps

module time_counter (
    input wire sys_clk,
    input wire rst_n,
    input wire clk_1hz_en,
    input wire inc_seconds_ui,  // UI increments seconds (for setting)
    input wire inc_minutes_ui,  // UI increments minutes (for setting)
    input wire inc_hours_ui,    // UI increments hours (for setting)
    output reg [5:0] seconds,
    output reg [5:0] minutes,
    output reg [4:0] hours
);

    localparam SEC_MAX = 59;
    localparam MIN_MAX = 59;
    localparam HOUR_MAX_24HR = 23; // Using 23 for 0-23 hours format

    // Time update logic
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all time registers
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours <= 5'd0;
        end else begin
            // --- UI Set Logic (Higher Priority) ---
            // If any UI increment button is pressed, handle it
            if (inc_seconds_ui) begin
                seconds <= (seconds == SEC_MAX) ? 6'd0 : seconds + 1;
            end else if (inc_minutes_ui) begin
                minutes <= (minutes == MIN_MAX) ? 6'd0 : minutes + 1;
            end else if (inc_hours_ui) begin
                hours <= (hours == HOUR_MAX_24HR) ? 5'd0 : hours + 1;
            end
            // --- Normal Clock Counting Logic (Lower Priority) ---
            // Only advance time on 1Hz pulse if NO UI increment is active
            else if (clk_1hz_en) begin
                if (seconds == SEC_MAX) begin // Seconds rollover
                    seconds <= 6'd0;
                    if (minutes == MIN_MAX) begin // Minutes rollover
                        minutes <= 6'd0;
                        if (hours == HOUR_MAX_24HR) begin // Hours rollover (23 -> 00)
                            hours <= 5'd0;
                        end else begin
                            hours <= hours + 1; // Increment hours
                        end
                    end else begin
                        minutes <= minutes + 1; // Increment minutes
                    end
                end else begin
                    seconds <= seconds + 1; // Increment seconds
                end
            end
        end
    end

endmodule
