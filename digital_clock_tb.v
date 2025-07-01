`timescale 1ns/1ps

module digital_clock_top_tb();

   
    reg sys_clk;
    reg rst_n;
    reg mode_btn_tb; 
    reg set_btn_tb; 
reg alarm_off_btn_tb;
reg alarm_arm_btn_tb;
   
    wire [5:0] current_seconds_out;
    wire [5:0] current_minutes_out;
    wire [4:0] current_hours_out;
    wire alarm_active_out_tb;
    wire [2:0] display_mode_debug_tb;
    wire ui_inc_seconds_en_out;
wire ui_inc_current_minutes_en_out;
wire ui_inc_current_hours_en_out;

    digital_clock_top dut (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .mode_btn(mode_btn_tb),
        .set_btn(set_btn_tb),
        .current_seconds(current_seconds_out),
        .current_minutes(current_minutes_out),
        .current_hours(current_hours_out),.ui_inc_seconds_en_out(ui_inc_seconds_en_out),
    .ui_inc_current_minutes_en_out(ui_inc_current_minutes_en_out),
    .ui_inc_current_hours_en_out(ui_inc_current_hours_en_out),
    
    .alarm_off_btn(alarm_off_btn_tb),
    .alarm_arm_btn(alarm_arm_btn_tb),
        .alarm_active_out(alarm_active_out_tb),
        .display_mode_debug(display_mode_debug_tb)
    );

    
    always #5 sys_clk = ~sys_clk; 

    
    initial begin
        
        sys_clk = 1'b0;
        rst_n   = 1'b0; 
        mode_btn_tb = 1'b0;
        set_btn_tb = 1'b0;

	 $display("Time %0t: Clock running normally...", $time);
    #50_000_000;
    
    $display("Time %0t: Pressing MODE button to enter SET_HOURS...", $time);
    mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;
  
    $display("Time %0t: Pressing SET button to increment CURRENT HOURS...", $time);
    repeat(3) begin set_btn_tb = 1'b1; #100; set_btn_tb = 1'b0; #500; end 
    $display("Time %0t: Pressing MODE button to enter SET_MINUTES...", $time);
    mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;
        $display("Time %0t: Pressing SET button to increment CURRENT MINUTES...", $time);
    repeat(5) begin set_btn_tb = 1'b1; #100; set_btn_tb = 1'b0; #500; end    $display("Time %0t: Pressing MODE button to enter SET_ALARM_HOURS...", $time);
    mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;
    
    $display("Time %0t: Pressing SET button to increment ALARM HOURS...", $time);
    repeat(3) begin set_btn_tb = 1'b1; #100; set_btn_tb = 1'b0; #500; end
    $display("Time %0t: Pressing MODE button to enter SET_ALARM_MINUTES...", $time);
    mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;
    
    $display("Time %0t: Pressing SET button to increment ALARM MINUTES...", $time);
    repeat(7) begin set_btn_tb = 1'b1; #100; set_btn_tb = 1'b0; #500; end     $display("Time %0t: Cycling back to DISPLAY_TIME...", $time);
    mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;
    $display("Time %0t: Arming the alarm...", $time);
    alarm_arm_btn_tb = 1'b1; 
    #100;
    alarm_arm_btn_tb = 1'b0;
    #500;
    $display("Time %0t: Waiting for current time to match alarm time (03:07)...", $time);
    #1200_000_000; 
                      $display("Time %0t: Alarm should be active now! alarm_active_out: %b", $time, alarm_active_out_tb);
    #10_000_000;     $display("Time %0t: Pressing ALARM_OFF button...", $time);
    alarm_off_btn_tb = 1'b1;
    #100; 
    alarm_off_btn_tb = 1'b0;
    #500;
    $display("Time %0t: Alarm should be off now! alarm_active_out: %b", $time, alarm_active_out_tb);

       #20_000_000;    $display("Time %0t: Final check. Alarm should be off. alarm_active_out: %b", $time, alarm_active_out_tb);

    $display("Time %0t: Digital Clock Top-Level Simulation Finished.", $time);

                #100;
        alarm_off_btn_tb = 1'b0;
        alarm_arm_btn_tb = 1'b0;
        
        rst_n = 1'b1;
        #50;

        $display("Time %0t: Clock running normally...", $time);
        #50_000_000; 
        
        $display("Time %0t: Pressing MODE button to enter SET_HOURS...", $time);
        mode_btn_tb = 1'b1;
        #100; 
        mode_btn_tb = 1'b0;
        #500; 
        $display("Time %0t: Pressing SET button to increment HOURS...", $time);
        repeat(3) begin
            set_btn_tb = 1'b1;
            #100;
            set_btn_tb = 1'b0;
            #500;
        end

        $display("Time %0t: Pressing MODE button to enter SET_MINUTES...", $time);
        mode_btn_tb = 1'b1;
        #100;
        mode_btn_tb = 1'b0;
        #500;

        $display("Time %0t: Pressing SET button to increment MINUTES...", $time);
        repeat(5) begin
            set_btn_tb = 1'b1;
            #100;
            set_btn_tb = 1'b0;
            #500;
        end

        $display("Time %0t: Cycling through remaining modes...", $time);
        mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;   
  	mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500;
        mode_btn_tb = 1'b1; #100; mode_btn_tb = 1'b0; #500
        #10_000_000; 

        $display("Time %0t: Top-level Digital Clock Simulation Finished.", $time);
        $finish;
    end

  
    initial begin
        $dumpfile("digital_clock_top.vcd");
        $dumpvars(0, digital_clock_top_tb);
end

endmodule
