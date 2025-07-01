module clockdivider(
    input sys_clk,
    input rst_n,
    output reg clk_1hz_en
);

parameter CLOCK_FREQ = 1000;
localparam COUNT_MAX = CLOCK_FREQ - 1;
reg [26:0] counter;

always @ (posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 27'b0;
        clk_1hz_en <= 1'b0;
    end else begin
        if (counter == COUNT_MAX) begin
            counter <= 27'b0;
            clk_1hz_en <= 1'b1;
        end else begin
            counter <= counter + 1;
            clk_1hz_en <= 1'b0;
        end
    end
end

endmodule

