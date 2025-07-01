`timescale 1ns/1ps

module alarm_registers_tb();

    
    reg sys_clk;
    reg rst_n;
    reg inc_alarm_hours_en_tb;   
    reg inc_alarm_minutes_en_tb; 
    wire [4:0] alarm_hours_out;
    wire [5:0] alarm_minutes_out;

    alarm_registers dut (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .inc_alarm_hours_en(inc_alarm_hours_en_tb),
        .inc_alarm_minutes_en(inc_alarm_minutes_en_tb),
        .alarm_hours(alarm_hours_out),
        .alarm_minutes(alarm_minutes_out)
    );

    always #5 sys_clk = ~sys_clk;

    initial begin
 
        sys_clk = 1'b0;
        rst_n   = 1'b0; 
	inc_alarm_hours_en_tb = 1'b0;
        inc_alarm_minutes_en_tb = 1'b0;

        #100;

        rst_n = 1'b1;
        #50; 

        $display("Time %0t: Initial alarm time (should be 00:00): %0d:%0d", $time, alarm_hours_out, alarm_minutes_out);

            $display("Time %0t: Incrementing minutes...", $time);
        repeat (3) begin 
            inc_alarm_minutes_en_tb = 1'b1; 
            #10;                            
            inc_alarm_minutes_en_tb = 1'b0; 
            #50;                           
            $display("Time %0t: Alarm time: %0d:%0d", $time, alarm_hours_out, alarm_minutes_out);
        end

                $display("Time %0t: Incrementing hours...", $time);
        repeat (2) begin 
            inc_alarm_hours_en_tb = 1'b1;
            #10;                         
            inc_alarm_hours_en_tb = 1'b0; 
            #50;                         
            $display("Time %0t: Alarm time: %0d:%0d", $time, alarm_hours_out, alarm_minutes_out);
        end

       
        $display("Time %0t: Testing minute rollover (incrementing to 59, then 00)...", $time);
        
        repeat (50) begin 
            inc_alarm_minutes_en_tb = 1'b1;
            #10;
            inc_alarm_minutes_en_tb = 1'b0;
            #50;
        end
        $display("Time %0t: Alarm time after rollover check: %0d:%0d", $time, alarm_hours_out, alarm_minutes_out); 

        $display("Time %0t: Testing hour rollover (incrementing to 23, then 00)...", $time);
        
        repeat (20) begin 
            inc_alarm_hours_en_tb = 1'b1;
            #10;
            inc_alarm_hours_en_tb = 1'b0;
            #50;
        end
        $display("Time %0t: Alarm time after rollover check: %0d:%0d", $time, alarm_hours_out, alarm_minutes_out);

        #100; 
        $display("Alarm Registers Testbench Finished.");
        $finish; 
    end

    initial begin
        $dumpfile("alarm_registers.vcd");
        $dumpvars(0, alarm_registers_tb); 
    end

endmodule
