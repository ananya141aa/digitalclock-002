`timescale 1ns/1ps
module clockdivider_tb();
reg sys_clk;
reg rst_n;
wire clk_1hz_en;
localparam SIM_DURATIONS_NS=1100000000;
clockdivider dut (
.sys_clk(sys_clk),
.rst_n(rst_n),
.clk_1hz_en(clk_1hz_en)
);
always #5 sys_clk = ~sys_clk;
initial begin
sys_clk = 1'b0;
rst_n = 1'b0;
#100;
rst_n = 1'b1;
#1100000000;
$monitor("Time = %0t ns, clk_1hz_en = %b", $time, clk_1hz_en);
$display("Simulation finished at time:%0t ns. Check clk_1hz_en for pulses.",$time);
$finish;
end
initial begin
$dumpfile("clock_divider.vcd");
$dumpvars(0,sys_clk,rst_n,clk_1hz_en);
end
endmodule


