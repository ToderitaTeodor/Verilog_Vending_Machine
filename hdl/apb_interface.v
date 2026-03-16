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

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni								) control_reg_o <= 8'b0	   ; else
if(paddr_i == 8'h00 && pwrite_i && psel_i) control_reg_o <= pwdata_i;	

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni								) money_o <= 8'b0	 ; else
if(paddr_i == 8'h01 && pwrite_i && psel_i) money_o <= pwdata_i;

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni								) item_o <= 8'b0	; else
if(paddr_i == 8'h02 && pwrite_i && psel_i) item_o <= pwdata_i;

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni						  ) valid_o <= 1'b0; else 
if(psel_i && penable_i && pwrite_i) valid_o <= 1'b1; else
if(valid_o						  ) valid_o <= 1'b0;

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni ) pready_o <= 1'b0; else
if(pready_o) pready_o <= 1'b0; else
if(psel_i && ~penable_i) pready_o <= 1'b1; // pready_o va fi 1 mereu in al doilea tact de ceas 

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni) prdata_o <= 8'b0; else
if(psel_i && ~penable_i && ~pwrite_i)
	case(paddr_i)
	
	8'h00 : prdata_o <= control_reg_o;
	
	8'h01 : prdata_o <= money_o;
	
	8'h02 : prdata_o <= item_o;
	
	default : prdata_o <= 8'b0;
	
	endcase
	
endmodule