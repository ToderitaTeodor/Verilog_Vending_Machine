module apb_interface #(

	parameter ADDRESS_WIDTH = 8,
    parameter WDATA_WIDTH   = 8,
    parameter RDATA_WIDTH   = 8

)(

	input 						   clk_i     	,
	input 						   rst_ni    	,
	input 						   psel_i    	,
	input 						   penable_i 	,
	input 						   pwrite_i  	, 
	input      [ADDRESS_WIDTH-1:0] paddr_i   	,
	input      [WDATA_WIDTH  -1:0] pwdata_i  	,
	output reg [RDATA_WIDTH  -1:0] prdata_o  	,
	output reg 					   pready_o  	,
	
	output reg 					   valid_o   	,
	output reg  			 [7:0] money_o      ,
	output reg 				 [7:0] control_reg_o,
	output reg				 [7:0] item_o		
	
);

endmodule