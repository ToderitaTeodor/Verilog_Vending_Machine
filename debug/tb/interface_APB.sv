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
  
  // 1. Address must be stable during ACCESS phase compared to SETUP phase
  property paddr_stable_during_access;
    @(posedge clk_i) disable iff (!rst_ni)
    (psel_i && penable_i) |-> $stable(paddr_i);
  endproperty

  // 2. PREADY cannot be HIGH if the peripheral is not selected (PSEL = 0)
  property pready_psel_is_eq;
    @(posedge clk_i) disable iff (!rst_ni)
    pready_o |-> psel_i;
  endproperty

  // 3. PENABLE must have been active in the cycle BEFORE PREADY falls
  property penable_active_on_pready_fall; 
    @(posedge clk_i) disable iff (!rst_ni)
    $fell(pready_o) |-> $past(penable_i);
  endproperty

  // 4. PREADY must fall when PSEL falls
  property pready_fall_on_psel_fall;
    @(posedge clk_i) disable iff (!rst_ni)
    $fell(psel_i) |-> $fell(pready_o);
  endproperty

  // 5. PENABLE must fall when PSEL falls
  property penable_fall_on_psel_fall;
    @(posedge clk_i) disable iff (!rst_ni)
    $fell(psel_i) |-> $fell(penable_i);
  endproperty


  // ================= ASSERTIONS & ERROR MESSAGES =================

  assert property (paddr_stable_during_access) 
    else $error("[PROTOCOL VIOLATION] paddr_i unstable in ACCESS PHASE at: %0t", $time);
  
  assert property (pready_psel_is_eq)
    else $error("[PROTOCOL VIOLATION] pready_o is HIGH but psel_i is LOW at: %0t", $time);

  assert property (penable_active_on_pready_fall)
    else $error("[PROTOCOL VIOLATION] penable_i was not active before pready_o fall at: %0t", $time);

  assert property (pready_fall_on_psel_fall)
    else $error("[PROTOCOL VIOLATION] pready_o did not fall on psel_i fall at: %0t", $time);
  
  assert property (penable_fall_on_psel_fall)
    else $error("[PROTOCOL VIOLATION] penable_i did not fall on psel_i fall at: %0t", $time);


endinterface