`timescale 1ns/1ps

module alarm_comparator_tb();

    reg sys_clk_tb;
    reg rst_n_tb;
    reg [4:0] current_hours_in_tb;
    reg [5:0] current_minutes_in_tb;
    reg [4:0] alarm_hours_in_tb;
    reg [5:0] alarm_minutes_in_tb;
    reg alarm_enable_in_tb;
    reg alarm_off_btn_tb;
    wire alarm_trigger_out_tb;
    wire clk_1hz_en_tb;
    alarm_comparator dut (
        .sys_clk(sys_clk_tb),
        .rst_n(rst_n_tb),
        .clk_1hz_en(clk_1hz_en_tb),
        .current_hours_in(current_hours_in_tb),
        .current_minutes_in(current_minutes_in_tb),
        .alarm_hours_in(alarm_hours_in_tb),
        .alarm_minutes_in(alarm_minutes_in_tb),
        .alarm_enable_in(alarm_enable_in_tb),
        .alarm_off_btn(alarm_off_btn_tb),
        .alarm_trigger_out(alarm_trigger_out_tb)
    );

    always #5 sys_clk_tb = ~sys_clk_tb;

    reg clk_1hz_reg;
    always #5000000 clk_1hz_reg = ~clk_1hz_reg; 
    assign clk_1hz_en_tb = clk_1hz_reg; 
    initial begin
       
        sys_clk_tb = 1'b0;
        rst_n_tb = 1'b0;
        clk_1hz_reg = 1'b0;
        current_hours_in_tb = 5'd0;
        current_minutes_in_tb = 6'd0;
        alarm_hours_in_tb = 5'd0;
        alarm_minutes_in_tb = 6'd0;
        alarm_enable_in_tb = 1'b0;
        alarm_off_btn_tb = 1'b0;

        #100;

        rst_n_tb = 1'b1;
        #50;

        $display("Time %0t: Initial state. Alarm should be off.", $time);

        current_hours_in_tb = 5'd10;
        current_minutes_in_tb = 6'd30;
        alarm_hours_in_tb = 5'd10;
        alarm_minutes_in_tb = 6'd30;
        alarm_enable_in_tb = 1'b0; 
        #200;

        $display("Time %0t: Alarm disabled. Current: %0d:%0d, Alarm: %0d:%0d. Trigger: %b (should be 0)", $time, current_hours_in_tb, current_minutes_in_tb, alarm_hours_in_tb, alarm_minutes_in_tb, alarm_trigger_out_tb);

        alarm_enable_in_tb = 1'b1; 
        current_minutes_in_tb = 6'd31;
        #200; 

        $display("Time %0t: Alarm enabled, no match. Trigger: %b (should be 0)", $time, alarm_trigger_out_tb);

        current_minutes_in_tb = 6'd30; 
        #10; 
        #5000000;

        $display("Time %0t: Alarm enabled, match! Trigger: %b (should be 1)", $time, alarm_trigger_out_tb);

        $display("Time %0t: Alarm ringing. Pressing OFF button...", $time);
        alarm_off_btn_tb = 1'b1;
        #10;
        alarm_off_btn_tb = 1'b0;
        #50;

        $display("Time %0t: OFF button pressed. Trigger: %b (should be 0)", $time, alarm_trigger_out_tb);

        $display("Time %0t: Checking re-trigger (should be off now). Trigger: %b (should be 0)", $time, alarm_trigger_out_tb);
        #5000000; 

        #100; 
        $display("Alarm Comparator Testbench Finished.");
        $finish;
    end

    initial begin
        $dumpfile("alarm_comparator.vcd");
        $dumpvars(0, alarm_comparator_tb);
    end

endmodule
