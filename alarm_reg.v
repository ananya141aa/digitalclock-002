`timescale 1ns/1ps

module alarm_reg (
    input wire sys_clk,         
    input wire rst_n,           

    input wire inc_alarm_hours_en,   
    input wire inc_alarm_minutes_en,

    output reg [4:0] alarm_hours,    
    output reg [5:0] alarm_minutes   
);

    localparam ALARM_MIN_MAX = 59;
    localparam ALARM_HOUR_MAX_24HR = 23;


    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
          
            alarm_hours   <= 5'd0;
            alarm_minutes <= 6'd0;
        end
        else begin
           
            if (inc_alarm_hours_en) begin
                if (alarm_hours == ALARM_HOUR_MAX_24HR) begin
                    alarm_hours <= 5'd0; 
                end else begin
                    alarm_hours <= alarm_hours + 1;
                end
            end
            
            else if (inc_alarm_minutes_en) begin
                if (alarm_minutes == ALARM_MIN_MAX) begin
                    alarm_minutes <= 6'd0; // Roll over
                end else begin
                    alarm_minutes <= alarm_minutes + 1;
                end
            end
            
        end
    end

endmodule
