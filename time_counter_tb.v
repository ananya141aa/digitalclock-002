`timescale 1ns/1ps

module time_counter_tb();
    reg sys_clk;
    reg rst_n;
    reg clk_1hz_tb;
    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [4:0] hours;

    
    time_counter dut (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .clk_1hz_en(clk_1hz_tb),
	.seconds(seconds),
        .minutes(minutes),
        .hours(hours)
    );

    always #5 sys_clk = ~sys_clk;

        always #50 clk_1hz_tb = ~clk_1hz_tb; 
   
    initial begin
        sys_clk = 1'b0;
        rst_n = 1'b0;
        clk_1hz_tb = 1'b0;
        #100;
        rst_n = 1'b1;

                #360000; 
        $display("Time Counter Simulation Finished.");
        $finish;
    end
    initial begin
        $dumpfile("time_counter.vcd");
        $dumpvars(0, time_counter_tb); 
    end

endmodule
