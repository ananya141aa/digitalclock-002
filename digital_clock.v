`timescale 1ns/1ps

module digital_clock_top (
    input wire sys_clk,     
    input wire rst_n,       
    input wire mode_btn,    
    input wire set_btn,
    input wire alarm_off_btn,
    input wire alarm_arm_btn, 

    output wire [5:0] current_seconds,
    output wire [5:0] current_minutes, 
    output wire [4:0] current_hours,  
    output wire alarm_active_out, 
    output wire [2:0] display_mode_debug,

    // Debug outputs for GTKWave
    output wire ui_inc_seconds_en_out,
    output wire ui_inc_current_minutes_en_out,
    output wire ui_inc_current_hours_en_out
);

    wire [4:0] alarm_hours_wire;
    wire [5:0] alarm_minutes_wire;
    wire alarm_trigger_wire; 
    wire alarm_enable_from_fsm; 
    wire clk_1hz_en;           

    // Internal control signals from FSM
    wire ui_inc_seconds_en;    
    wire ui_inc_current_minutes_en;   
    wire ui_inc_current_hours_en; 
    wire ui_inc_alarm_hours_en;
    wire ui_inc_alarm_minutes_en;
    wire ui_load_time_en;      
    wire ui_set_alarm_mode;  
    wire [2:0] ui_display_mode;

    clockdivider clk_div_inst (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .clk_1hz_en(clk_1hz_en)
    );

    time_counter time_cnt_inst (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .clk_1hz_en(clk_1hz_en),
        .inc_seconds_ui(ui_inc_seconds_en), 
        .inc_minutes_ui(ui_inc_current_minutes_en), 
        .inc_hours_ui(ui_inc_current_hours_en),
        .seconds(current_seconds),
        .minutes(current_minutes),
        .hours(current_hours)
    );

    ui_fsm ui_fsm_inst (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .mode_btn(mode_btn),
        .set_btn(set_btn),

        .increment_seconds_en(ui_inc_seconds_en), 
        .increment_minutes_en(ui_inc_current_minutes_en),  
        .increment_hours_en(ui_inc_current_hours_en),       
        .inc_current_hours_en(ui_inc_current_hours_en),    
        .inc_current_minutes_en(ui_inc_current_minutes_en),   
        .inc_alarm_hours_en(ui_inc_alarm_hours_en),           
        .inc_alarm_minutes_en(ui_inc_alarm_minutes_en),   
        .load_time_en(ui_load_time_en),
        .set_alarm_mode(ui_set_alarm_mode),
        .display_mode_out(ui_display_mode)
    );

    alarm_reg alarm_reg_inst (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .inc_alarm_hours_en(ui_inc_alarm_hours_en),
        .inc_alarm_minutes_en(ui_inc_alarm_minutes_en),
        .alarm_hours(alarm_hours_wire),         
        .alarm_minutes(alarm_minutes_wire)    
    );

    alarm_comparator alarm_comp_inst (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .clk_1hz_en(clk_1hz_en), 
        .current_hours_in(current_hours),
        .current_minutes_in(current_minutes),
        .alarm_hours_in(alarm_hours_wire), 
        .alarm_minutes_in(alarm_minutes_wire), 
        .alarm_enable_in(alarm_enable_from_fsm), 
        .alarm_off_btn(alarm_off_btn), 
        .alarm_trigger_out(alarm_trigger_wire)
    );

    assign display_mode_debug = ui_display_mode;
    assign alarm_active_out = alarm_trigger_wire;

    // ✅ Connect internal FSM wires to top-level debug outputs
    assign ui_inc_seconds_en_out          = ui_inc_seconds_en;
    assign ui_inc_current_minutes_en_out  = ui_inc_current_minutes_en;
    assign ui_inc_current_hours_en_out    = ui_inc_current_hours_en;

endmodule

