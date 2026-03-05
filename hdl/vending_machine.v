module vending_machine #( 

	parameter ADDRESS_WIDTH = 8,
    parameter WDATA_WIDTH   = 8,
    parameter RDATA_WIDTH   = 8,
	parameter CHANGE_WIDTH  = 8
	
)(
	input 						       clk_i     ,
	input 						  	   rst_ni    ,
	input 						  	   psel_i    ,
	input 						  	   penable_i ,
	input 						  	   pwrite_i  , 
	input      [ADDRESS_WIDTH -1 : 0]  paddr_i   ,
	input      [WDATA_WIDTH   -1 : 0]  pwdata_i  ,
	output reg [RDATA_WIDTH   -1 : 0]  prdata_o  , 
												 
	output reg 						   pready_o  ,
	output reg 						   valid_o   ,
	output reg						   error_o   ,
	output reg						   success_o ,
	output reg [CHANGE_WIDTH  -1 : 0]  change_o 
	
);



endmodule