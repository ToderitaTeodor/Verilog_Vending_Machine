interface interface_output #(
  parameter CHANGE_WIDTH = 8
)(input logic clk_i, rst_ni);

  logic                    alarm_o;
  logic                    success_o;
  logic [CHANGE_WIDTH-1:0] change_o;
  
  clocking monitor_cb @(posedge clk_i);
    default input #1 output #1;
    input alarm_o;
    input success_o;
    input change_o;
  endclocking
  
  modport MONITOR (clocking monitor_cb, input clk_i, rst_ni);

  // 1. Alarm and Success cannot be active simultaneously
  property alarm_success_mutex;
    @(posedge clk_i) disable iff (!rst_ni)
    !(alarm_o && success_o);
  endproperty

  // 2. Output control signals must never be X or Z
  property output_controls_known;
    @(posedge clk_i) disable iff (!rst_ni)
    !$isunknown({alarm_o, success_o});
  endproperty

  // 3. Change value must never be X or Z
  property change_known;
    @(posedge clk_i) disable iff (!rst_ni)
    !$isunknown(change_o);
  endproperty

  // ================= ASSERTIONS & ERROR MESSAGES =================

  // 1.
  assert property (alarm_success_mutex)
    else $error("[PROTOCOL VIOLATION] alarm_o and success_o are both HIGH at: %0t", $time);

  // 2.
  assert property (output_controls_known)
    else $error("[PROTOCOL VIOLATION] alarm_o or success_o is unknown at: %0t", $time);

  // 3.
  assert property (change_known)
    else $error("[PROTOCOL VIOLATION] change_o is unknown at: %0t", $time);

endinterface