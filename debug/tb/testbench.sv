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
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  initial begin
    reset = 0;
    #15 reset = 1;
  end
  
  // 1. Instantiate Interfaces
  interface_output out_intf(clk, reset);
  interface_APB    apb_intf(clk, reset);

  // 2. Instantiate the Top-Level DUT (not just the protocol)
  vending_machine #(
    .ADDRESS_WIDTH(8),
    .WDATA_WIDTH(8),
    .RDATA_WIDTH(8),
    .CHANGE_WIDTH(8)
  ) DUT (
    .clk_i     (clk),
    .rst_ni    (reset),
    // APB Interface connections
    .psel_i    (apb_intf.psel_i),
    .penable_i (apb_intf.penable_i),
    .pwrite_i  (apb_intf.pwrite_i),
    .paddr_i   (apb_intf.paddr_i),
    .pwdata_i  (apb_intf.pwdata_i),
    .prdata_o  (apb_intf.prdata_o),
    .pready_o  (apb_intf.pready_o),
    // Output Interface connections
    .alarm_o   (out_intf.alarm_o),
    .success_o (out_intf.success_o),
    .change_o  (out_intf.change_o)
  );

  // 3. Link the Test Program (Choose one test to include)
  // Ensure the test file is included in your vlog command or here
  test t1(out_intf, apb_intf);

endmodule