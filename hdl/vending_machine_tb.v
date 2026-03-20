`timescale 1ns/1ps

module venindg_machine_tb;

localparam CLK_FREQ_TB = 10;
localparam ADDRESS_WIDTH = 8;
localparam WDATA_WIDTH = 8;
localparam RDATA_WIDTH = 8;
localparam CHANGE_WIDTH = 8;

reg clk, rst_n, psel, penable, pwrite;
wire alarm_o, success_o;

reg  [ADDRESS_WIDTH-1:0] paddr;
reg  [WDATA_WIDTH  -1:0] pwdata;

wire [RDATA_WIDTH  -1:0] prdata;

wire [CHANGE_WIDTH -1:0] change_o;

wire pready;

vending_machine #( 

	.ADDRESS_WIDTH(ADDRESS_WIDTH),
    .WDATA_WIDTH  (WDATA_WIDTH),
    .RDATA_WIDTH  (RDATA_WIDTH),
	.CHANGE_WIDTH (CHANGE_WIDTH)
	
) DUT_test_bench (
	.clk_i    (clk),
	.rst_ni   (rst_n),
			  
	.psel_i   (psel),
	.penable_i(penable),
	.pwrite_i (pwrite), 
	.paddr_i  (paddr),
	.pwdata_i (pwdata),
			  
	.prdata_o (prdata), 
	.pready_o (pready),
			  
	.alarm_o  (alarm_o),
	.success_o(success_o),
	.change_o (change_o)
	
);

task write_reg(
	input[ADDRESS_WIDTH-1:0] address,
	input[WDATA_WIDTH  -1:0] data
);
begin
	psel    <= 1'b1;
	penable <= 1'b0;
	pwrite  <= 1'b1;
	paddr   <= address;
	pwdata  <= data;
	
	@(posedge clk);
	penable <= 1'b1;
	
	wait(pready);
	@(posedge clk);
	
	psel    <= 1'b0;
	penable <= 1'b0;

end
endtask

initial begin
	clk = 0;
	forever #(CLK_FREQ_TB/2.0) clk = ~clk;
	
end


initial begin
	rst_n <= 1'b1;
	@(posedge clk);
	@(posedge clk);
	rst_n <= 1'b0;
	@(posedge clk);
	@(posedge clk);
	rst_n <= 1'b1;
	@(posedge clk);
	
	write_reg(8'h01, 8'd52);
	write_reg(8'h02, 8'd1);
	
	@(posedge clk);
	write_reg(8'h00, 8'd0);
	
	repeat(10) @(posedge clk);
	
	write_reg(8'h01, 8'd12);
	write_reg(8'h02, 8'd2);
	
	@(posedge clk);
	write_reg(8'h00, 8'd0);
	
	repeat(10) @(posedge clk);
	
	write_reg(8'h00, 8'd1);
	
	@(posedge clk);
	write_reg(8'h00, 8'd0);
	
	repeat(5) @(posedge clk);
	
	write_reg(8'h01, 8'd14);
	write_reg(8'h02, 8'd1);
	write_reg(8'h00, 8'd2);
	
	@(posedge clk);
	write_reg(8'h00, 8'd0);
	
	#800;
	
	$display("Final simulare la timpul %0t", $time);
	$stop;
	
end

endmodule