`timescale 1ns / 1ps

module vending_machine_tb;

localparam CLK_FREQ_TB   = 10;
localparam ADDRESS_WIDTH =  8;
localparam WDATA_WIDTH   =  8;
localparam RDATA_WIDTH   =  8;
localparam CHANGE_WIDTH  =  8;

reg clk, rst_n, psel, penable, pwrite;
wire alarm_o, success_o;

reg  [ADDRESS_WIDTH-1:0] paddr;
reg  [WDATA_WIDTH  -1:0] pwdata;
wire [RDATA_WIDTH  -1:0] prdata;

wire [CHANGE_WIDTH -1:0] change_o;

wire pready, valid;

wire [7:0] money, control_reg, item;

vending_machine #( 

	.ADDRESS_WIDTH(ADDRESS_WIDTH),
    .WDATA_WIDTH  (WDATA_WIDTH  ),
    .RDATA_WIDTH  (RDATA_WIDTH  ),
	.CHANGE_WIDTH (CHANGE_WIDTH )
	
) DUT_vending_machine (
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
	bit[ADDRESS_WIDTH-1:0] address,
	bit[WDATA_WIDTH  -1:0] data   
);
	psel    <= 1	  ;
	penable <= 0	  ;
	pwrite  <= 1	  ;
	paddr   <= address;
	pwdata  <= data   ;
	
	@(posedge clk);
	penable <= 1;
	@(posedge clk iff pready);
	psel <= 0;
	penable <= 0;
endtask

initial begin
    clk = 0;
    forever #(CLK_FREQ_TB/2.0) clk = ~clk;
end

initial begin
    rst_n <= 1'b1 ;
    @(posedge clk);
    @(posedge clk);
    rst_n <= 1'b0 ;
    @(posedge clk);
    @(posedge clk);
    rst_n <= 1'b1 ;
    @(posedge clk);

	write_reg(0x01, 20);
    
    #800;
    
    $display("Final simulare la timpul %0t", $time);
    $stop;
end

endmodule