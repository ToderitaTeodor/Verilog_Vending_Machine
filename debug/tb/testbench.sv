//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//tbench_top or testbench top, this is the top most file, in which DUT(Design Under Test) and Verification environment are connected. 
//-------------------------------------------------------------------------

//including interfcae and testcase files
`include "interface_output.sv"
`include "interface_APB.sv"
//`include "apb_protocol.v"


//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test.sv"
//`include "wr_rd_test.sv"
//`include "default_rd_test.sv"
//----------------------------------------------------------------


module testbench;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #15 reset = 0;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  interface_output out_intf(clk, reset);
  interface_APB    apb_intf(clk, reset);

  //Testcase instance, interface handles are passed to test as arguments
  test t1(out_intf, apb_intf);

  logic [7:0]  tb_money_o;
  logic [7:0]  tb_control_reg_o;
  logic [7:0]  tb_item_o;

localparam CLK_FREQ_TB = 10;
localparam ADDRESS_WIDTH = 8;
localparam WDATA_WIDTH = 8;
localparam RDATA_WIDTH = 8;
localparam CHANGE_WIDTH = 8;

vending_machine #( 

	.ADDRESS_WIDTH(ADDRESS_WIDTH),
    .WDATA_WIDTH  (WDATA_WIDTH),
    .RDATA_WIDTH  (RDATA_WIDTH),
	.CHANGE_WIDTH (CHANGE_WIDTH)
	
) DUT_test_bench (
	.clk_i    (clk),
	.rst_ni   (rst_n),
			  
  .psel_i   (apb_intf.psel_i),
	.penable_i(penable),
	.pwrite_i (pwrite), 
	.paddr_i  (paddr),
	.pwdata_i (pwdata),
			  
	.prdata_o (prdata), 
	.pready_o (pready),
			  
  .alarm_o  (out_intf.alarm_o),
	.success_o(success_o),
	.change_o (change_o)
	
);
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
    
    // Add a delay to let the simulation run before stopping
    #1000; 
    $stop; 
  end

endmodule