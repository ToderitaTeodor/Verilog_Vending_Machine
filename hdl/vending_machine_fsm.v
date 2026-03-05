module vending_machine_fsm (

	input 			 clk_i		  ,
	input			 rst_ni		  ,
	input       	 apb_valid_i  ,
	input 	   [7:0] money_i	  ,
	input 	   [7:0] item_i		  ,
	input 	   [7:0] control_reg_i,
	output reg [7:0] change_o	  ,
	output reg  	 tranzaction_o,
	output reg 		 alarm_o

);

reg [7:0] mem_item [3:0];

reg [2:0] current_state ; 
reg [2:0] future_state  ; 

localparam state_idle 	 = 3'b000;
localparam state_evalue  = 3'b001;
localparam state_deliver = 3'b010;
localparam state_error 	 = 3'b011;
localparam state_admin   = 3'b100;
localparam state_alarm   = 3'b101;

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni) current_state <= state_idle  ; else
			current_state <= future_state;
			
always @(*)
case (current_state)

state_idle   : future_state <= (apb_valid_i) ? state_evalue : state_idle;

state_evalue : future_state <= (money_i >= mem_item[item_i]) ? state_deliver : state_error; 			  

state_deliver: ;

state_error  : future_state <= state_idle;

state_admin	 :   ;

state_alarm  :  ;

default: future_state <= state_idle;
        
endcase

endmodule