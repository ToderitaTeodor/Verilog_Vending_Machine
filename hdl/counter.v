module counter#(
	parameter CLK_FREQ = 16E06,
	parameter DELAY_S  =     2
)(
	input         clk_i,
	input        rst_ni,
	input      enable_i,
	output reg   tick_o
);

localparam integer MAX_TICKS = CLK_FREQ * DELAY_S;
localparam CNT_WIDTH = $clog2(MAX_TICKS);

reg [CNT_WIDTH-1 : 0] timer_counter;

always @(posedge clk_i or negedge rst_ni) begin
if(!rst_ni)
	timer_counter <= 0;
else if(enable_i)
	if(timer_counter == MAX_TICKS - 1)
		timer_counter <= timer_counter + 1;
	else
		timer_counter <= 0;
end

always @(posedge clk_i or negedge rst_ni) begin
if(!rst_ni)
	tick_o <= 0;
else if(enable_i)
	if(timer_counter == MAX_TICKS - 1)
		tick_o <= 1;
	else
		tick_o <= 0;
end

endmodule