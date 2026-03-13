interface interface_output #(
  parameter CHANGE_WIDTH = 8
)(input logic clk_i, rst_ni);
  
  logic                    alarm_o;
  logic                    success_o;
  logic [CHANGE_WIDTH-1:0] change_o;
  
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input alarm_o;
    input success_o;
    input change_o;
  endclocking
  
  modport MONITOR (clocking monitor_cb, input clk_i, rst_ni);
  
endinterface