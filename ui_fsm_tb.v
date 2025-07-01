`timescale 1ns/1ps 

module user_interface_fsm_tb();
    reg sys_clk;      
    reg rst_n;         
    reg mode_btn;      
    reg set_btn;       

    wire increment_seconds_en;
    wire increment_minutes_en;
    wire increment_hours_en;
    wire load_time_en;
    wire set_alarm_mode;
    wire [2:0] display_mode_out; 

   
    user_interface_fsm dut (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .mode_btn(mode_btn),
        .set_btn(set_btn),
        .increment_seconds_en(increment_seconds_en),
        .increment_minutes_en(increment_minutes_en),
        .increment_hours_en(increment_hours_en),
        .load_time_en(load_time_en),
        .set_alarm_mode(set_alarm_mode),
        .display_mode_out(display_mode_out)
    );

    always #5 sys_clk = ~sys_clk;

    
    initial begin
       
        sys_clk = 1'b0;
        rst_n   = 1'b0; 
        mode_btn = 1'b0;
        set_btn = 1'b0;
	#100;

       
        rst_n = 1'b1;
        #50; 

        
        $display("Time %0t: Current state: DISPLAY_TIME. Pressing MODE button...", $time);
        mode_btn = 1'b1; 
        #10;             
        mode_btn = 1'b0; 
        #50;            
        $display("Time %0t: Current state should be SET_HOURS. display_mode_out = %b", $time, display_mode_out);

        
        $display("Time %0t: In SET_HOURS. Pressing SET button...", $time);
        set_btn = 1'b1; 
	#10;           
        set_btn = 1'b0; 
        #50;            
        $display("Time %0t: increment_hours_en should have pulsed high. increment_hours_en = %b", $time, increment_hours_en);

        
        $display("Time %0t: In SET_HOURS. Pressing MODE button...", $time);
        mode_btn = 1'b1;
        #10;
        mode_btn = 1'b0;
        #50;
        $display("Time %0t: Current state should be SET_MINUTES. display_mode_out = %b", $time, display_mode_out);

        
        $display("Time %0t: In SET_MINUTES. Pressing SET button...", $time);
        set_btn = 1'b1;
        #10;
        set_btn = 1'b0;
        #50;
        $display("Time %0t: increment_minutes_en should have pulsed high. increment_minutes_en = %b", $time, increment_minutes_en);

        
        $display("Time %0t: In SET_MINUTES. Pressing MODE button...", $time);
        mode_btn = 1'b1;
        #10;
        mode_btn = 1'b0;
        #50;
        $display("Time %0t: Current state should be SET_ALARM_HOURS. display_mode_out = %b, set_alarm_mode = %b", $time, display_mode_out, set_alarm_mode);

       
        $display("Time %0t: In SET_ALARM_HOURS. Pressing SET button...", $time);
        set_btn = 1'b1;
        #10;
        set_btn = 1'b0;
        #50;
        $display("Time %0t: increment_hours_en should have pulsed high (for alarm). increment_hours_en = %b", $time, increment_hours_en);

        
        $display("Time %0t: In SET_ALARM_HOURS. Pressing MODE button...", $time);
        mode_btn = 1'b1;
        #10;
        mode_btn = 1'b0;
        #50;
        $display("Time %0t: Current state should be SET_ALARM_MINUTES. display_mode_out = %b, set_alarm_mode = %b", $time, display_mode_out, set_alarm_mode);
      	$display("Time %0t: In SET_ALARM_MINUTES. Pressing SET button...", $time);
        set_btn = 1'b1;
        #10;
        set_btn = 1'b0;
        #50;
        $display("Time %0t: increment_minutes_en should have pulsed high (for alarm). increment_minutes_en = %b", $time, increment_minutes_en);

        
        $display("Time %0t: In SET_ALARM_MINUTES. Pressing MODE button...", $time);
        mode_btn = 1'b1;
        #10;
        mode_btn = 1'b0;
        #55; 
        $display("Time %0t: Current state should be DISPLAY_TIME. display_mode_out = %b, load_time_en = %b", $time, display_mode_out, load_time_en);

        #100;
        $display("User Interface FSM Testbench Finished.");
        $finish; 
    end

       initial begin
        $dumpfile("user_interface_fsm.vcd"); 
        $dumpvars(0, user_interface_fsm_tb); 
end

endmodule
