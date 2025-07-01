`timescale 1ns/1ps

module ui_fsm (
    input wire sys_clk,    
    input wire rst_n,       
    input wire mode_btn,    
    input wire set_btn,   
    output reg increment_seconds_en, 
    output reg increment_minutes_en, 
    output reg increment_hours_en,   
    output reg load_time_en,         
    output reg set_alarm_mode,      
    output reg [2:0] display_mode_out,
    output reg inc_current_hours_en,   
output reg inc_current_minutes_en,
output reg inc_alarm_hours_en,     
output reg inc_alarm_minutes_en
);
    localparam [2:0] 
        S_DISPLAY_TIME      = 3'b000, 
        S_SET_HOURS         = 3'b001, 
        S_SET_MINUTES       = 3'b010, 
        S_SET_ALARM_HOURS   = 3'b011, 
        S_SET_ALARM_MINUTES = 3'b100; 
        

    reg [2:0] current_state;
    reg [2:0] next_state;

       reg mode_btn_d1, mode_btn_d2; 
    wire mode_btn_posedge;       

    reg set_btn_d1, set_btn_d2;
    wire set_btn_posedge;

   
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            mode_btn_d1 <= 1'b0;
            mode_btn_d2 <= 1'b0;
            set_btn_d1 <= 1'b0;
            set_btn_d2 <= 1'b0;
        end else begin
            mode_btn_d1 <= mode_btn;
            mode_btn_d2 <= mode_btn_d1;
            set_btn_d1 <= set_btn;
            set_btn_d2 <= set_btn_d1;
        end
    end

    assign mode_btn_posedge = (mode_btn_d1 == 1'b1) && (mode_btn_d2 == 1'b0);
    assign set_btn_posedge = (set_btn_d1 == 1'b1) && (set_btn_d2 == 1'b0);

   
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_DISPLAY_TIME; 
        end else begin
            current_state <= next_state; 
        end
    end

   
    always @(*) begin 

next_state             = current_state;
// OLD: increment_seconds_en   = 1'b0; // This was for generic seconds, not needed for manual
// OLD: increment_minutes_en   = 1'b0;
// OLD: increment_hours_en     = 1'b0;
load_time_en           = 1'b0;
set_alarm_mode         = 1'b0;
display_mode_out       = S_DISPLAY_TIME;

// NEW: Default all specific increment enables to 0
inc_current_hours_en   = 1'b0;
inc_current_minutes_en = 1'b0;
inc_alarm_hours_en     = 1'b0;
inc_alarm_minutes_en   = 1'b0;



 
                case (current_state)
            S_DISPLAY_TIME: begin
                display_mode_out = S_DISPLAY_TIME;
                if (mode_btn_posedge) begin 
                    next_state = S_SET_HOURS; 
                end
            end

            S_SET_HOURS: begin
                display_mode_out = S_SET_HOURS;
                set_alarm_mode   = 1'b0; 
                if (set_btn_posedge) begin 
                    inc_current_hours_en = 1'b1;
                end
                if (mode_btn_posedge) begin
                    next_state = S_SET_MINUTES;
                end
            end

            S_SET_MINUTES: begin
                display_mode_out = S_SET_MINUTES;
                set_alarm_mode   = 1'b0;
                if (set_btn_posedge) begin
                    inc_current_minutes_en = 1'b1;
                end
                if (mode_btn_posedge) begin
                    next_state = S_SET_ALARM_HOURS; 
                end
            end

            S_SET_ALARM_HOURS: begin
                display_mode_out = S_SET_ALARM_HOURS;
                set_alarm_mode   = 1'b1; 
                if (set_btn_posedge) begin
                    inc_alarm_hours_en = 1'b1; 
                end
                if (mode_btn_posedge) begin
                    next_state = S_SET_ALARM_MINUTES;
                end
            end

            S_SET_ALARM_MINUTES: begin
                display_mode_out = S_SET_ALARM_MINUTES;
                set_alarm_mode   = 1'b1;
                if (set_btn_posedge) begin
                    inc_alarm_minutes_en = 1'b1; 
                end
                if (mode_btn_posedge) begin
                    next_state = S_DISPLAY_TIME; 
                    load_time_en = 1'b1; 
                end
            end

            default: begin
                
            display_mode_out       = S_DISPLAY_TIME;
            increment_hours_en     = 1'b0;
            increment_minutes_en   = 1'b0;
            increment_seconds_en   = 1'b0;
            inc_alarm_hours_en     = 1'b0;
            inc_alarm_minutes_en   = 1'b0;
            load_time_en           = 1'b0;
            set_alarm_mode         = 1'b0;              
            end
        endcase
    end

endmodule
