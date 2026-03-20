module vending_machine_fsm (

	input 			 clk_i		  ,
	input			 rst_ni		  ,
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

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni						 ) tranzaction_o <= 1'b0; else
if(current_state == state_deliver) tranzaction_o <= 1'b1; else
								   tranzaction_o <= 1'b0;

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni						 ) alarm_o <= 1'b0; else
if(current_state == state_alarm  ) alarm_o <= 1'b1; else
								   alarm_o <= 1'b0;
								   
always @(posedge clk_i or negedge rst_ni)
if(~rst_ni						 ) change_o <= 8'b0						 ; else
if(current_state == state_deliver) change_o <= money_i - mem_item[item_i]; else
if(current_state == state_error  ) change_o <= money_i					 ; else
								   change_o <= 8'b0						 ;

always @(posedge clk_i or negedge rst_ni)
if(~rst_ni						 ) 
	begin
		mem_item[0] <= 8'd10; 
		mem_item[1] <= 8'd20;
		mem_item[2] <= 8'd30;
		mem_item[3] <= 8'd15;
	end
else

if(current_state == state_admin  ) mem_item[item_i] <= money_i;

always @(*)
case (current_state)

state_idle   : future_state <=  (control_reg_i[0]) ? state_alarm  : 
							    (control_reg_i[1]) ? state_admin  :
								(control_reg_i[2]) ? state_evalue : state_idle;

state_evalue : future_state <= (money_i >= mem_item[item_i]) ? state_deliver : state_error; 			  

state_deliver: future_state <= state_idle;

state_error  : future_state <= state_idle;

state_admin	 : future_state <= (control_reg_i[1]) ? state_admin : state_idle;

state_alarm  : future_state <= (control_reg_i[0]) ? state_alarm : state_idle;

default: future_state <= state_idle;
        
endcase

endmodule