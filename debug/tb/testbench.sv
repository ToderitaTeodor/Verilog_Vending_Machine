//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//tbench_top or testbench top, this is the top most file, in which DUT(Design Under Test) and Verification environment are connected. 
//-------------------------------------------------------------------------

//including interfcae and testcase files
`include "interface_output.sv"
`include "interface_APB.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
//`include "random_test.sv"
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
    reset = 0;
    #15 reset = 1;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  interface_output out_intf(clk, reset);
  interface_APB    apb_intf(clk, reset);

  //Testcase instance, interface handles are passed to test as arguments
  //test t1(out_intf, apb_intf);

  logic [7:0]  tb_money_o;
  logic [7:0]  tb_control_reg_o;
  logic [7:0]  tb_item_o;



  apb_interface  #(

  .ADDRESS_WIDTH  (8),
  .WDATA_WIDTH    (8),
  .RDATA_WIDTH    (8)

  )DUT_APB(
  .clk_i     	    (apb_intf.clk_i),
  .rst_ni    	    (apb_intf.rst_ni),
  .psel_i    	    (apb_intf.psel_i),
  .penable_i 	    (apb_intf.penable_i),
  .pwrite_i  	    (apb_intf.pwrite_i), 
  .paddr_i        (apb_intf.paddr_i),
  .pwdata_i       (apb_intf.pwdata_i),
  .prdata_o       (apb_intf.prdata_o),
  .pready_o  	    (apb_intf.pready_o),

  //Dut specific connections  
  .money_o       (tb_money_o),
  .control_reg_o (tb_control_reg_o),
  .item_o        (tb_item_o)
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