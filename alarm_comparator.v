`timescale 1ns/1ps

module alarm_comparator (
    input wire sys_clk,            
    input wire rst_n,             
    input wire clk_1hz_en,        

    input wire [4:0] current_hours_in,    
    input wire [5:0] current_minutes_in,  

    input wire [4:0] alarm_hours_in,       
    input wire [5:0] alarm_minutes_in,    

    input wire alarm_enable_in,    
    input wire alarm_off_btn,     

    output wire alarm_trigger_out   
);
    reg alarm_ringing_state;

   
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            alarm_ringing_state <= 1'b0; 
        end else if (clk_1hz_en) begin 
            if (alarm_enable_in && !alarm_ringing_state &&
                (current_hours_in == alarm_hours_in) &&
                (current_minutes_in == alarm_minutes_in)) begin
                alarm_ringing_state <= 1'b1; 
            end else if (alarm_off_btn) begin    
       		    alarm_ringing_state <= 1'b0; 
            end
        end
               if (!alarm_enable_in) begin
            alarm_ringing_state <= 1'b0;
        end
    end

        assign alarm_trigger_out = alarm_ringing_state;

endmodule
