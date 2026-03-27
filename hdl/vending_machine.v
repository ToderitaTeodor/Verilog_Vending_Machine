module vending_machine #( 

	parameter ADDRESS_WIDTH = 8,
    parameter WDATA_WIDTH   = 8,
    parameter RDATA_WIDTH   = 8,
	parameter CHANGE_WIDTH  = 8
	
)(
	input 						    clk_i     ,
	input 						  	rst_ni    ,
	
	input 						  	psel_i    ,
	input 						  	penable_i ,
	input 						  	pwrite_i  , 
	input   [ADDRESS_WIDTH -1 : 0]  paddr_i   ,
	input   [WDATA_WIDTH   -1 : 0]  pwdata_i  ,
	
	output  [RDATA_WIDTH   -1 : 0]  prdata_o  , 
	output  						pready_o  ,
	
	output						    alarm_o   ,
	output						    success_o ,
	output  [CHANGE_WIDTH  -1 : 0]  change_o 
	
);

wire [7:0] money, control_reg, item;

apb_protocol #(

	.ADDRESS_WIDTH(ADDRESS_WIDTH),
    .WDATA_WIDTH  (WDATA_WIDTH  ),
    .RDATA_WIDTH  (RDATA_WIDTH  )

) u_apb_protocol (
	.clk_i     	  (clk_i      ),
	.rst_ni    	  (rst_ni     ),
	
	.psel_i    	  (psel_i     ),
	.penable_i 	  (penable_i  ),
	.pwrite_i  	  (pwrite_i   ), 
	.paddr_i   	  (paddr_i    ),
	.pwdata_i  	  (pwdata_i   ),
	.prdata_o  	  (prdata_o   ),
	.pready_o  	  (pready_o	  ),

	.money_o      (money      ),
	.control_reg_o(control_reg),
	.item_o		  (item		  )
);


vending_machine_fsm u_vending_machine_fsm(

	.clk_i		  (clk_i ),
	.rst_ni		  (rst_ni),
    
	.money_i	  (money),
	.item_i		  (item),
	.control_reg_i(control_reg),
	
	.change_o	  (change_o),
	.tranzaction_o(success_o),
	.alarm_o	  (alarm_o)

);



endmodule