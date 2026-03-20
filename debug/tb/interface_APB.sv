interface interface_APB #(
  parameter ADDRESS_WIDTH = 8,
  parameter WDATA_WIDTH   = 8,
  parameter RDATA_WIDTH   = 8
)(input logic clk_i, rst_ni);
  
  logic [ADDRESS_WIDTH-1:0] paddr_i;
  logic                     psel_i;
  logic                     penable_i;
  logic                     pwrite_i;
  logic [WDATA_WIDTH-1:0]   pwdata_i;
  logic [RDATA_WIDTH-1:0]   prdata_o;
  logic                     pready_o;
  
  clocking driver_cb @(posedge clk_i);
    default input #1 output #1;
    output paddr_i;
    output psel_i;
    output penable_i;
    output pwrite_i;
    output pwdata_i;
    input  prdata_o;
    input  pready_o;
  endclocking
  
  clocking monitor_cb @(posedge clk_i);
    default input #1 output #1;
    input paddr_i;
    input psel_i;
    input penable_i;
    input pwrite_i;
    input pwdata_i;
    input prdata_o;
    input pready_o;  
  endclocking
  
  modport DRIVER  (clocking driver_cb, input clk_i, rst_ni);
  modport MONITOR (clocking monitor_cb, input clk_i, rst_ni);
  

  property paddr_stable_during_access;
    @(posedge clk_i) psel_i |=> $stable(paddr_i);
  endproperty

  assert property (paddr_stable_during_access) 
    else $error("[PROTOCOL VIOLATION] paddr_i unstable in ACCESS PHASE at: %0t", $time);

  property pready_psel_is_eq;
  @(posedge clk_i) pready_o == psel_i;
  endproperty

  assert property (pready_psel_is_eq)
    else $error("[PROTOCOL VIOLATION] pready is not equal to psel at: %0t", $time);
  


endinterface