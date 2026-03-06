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
`include "default_rd_test.sv"
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
    #15 reset =0;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  interface_output out_intf(clk, reset);
  interface_APB    apb_intf(clk, reset);

  //Testcase instance, interface handles are passed to test as arguments
  test t1(out_intf, apb_intf);

  //DUT instance, interface signals are connected to the DUT ports
  memory DUT (
    .clk(apb_intf.clk),
    .reset(apb_intf.reset),
    .addr(apb_intf.addr),
    .wr_en(apb_intf.wr_en),
    .rd_en(apb_intf.rd_en),
    .wdata(apb_intf.wdata),
    .rdata(out_intf.rdata) // rdata este monitorizat pe interfața de ieșire
   );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  $stop
endmodule