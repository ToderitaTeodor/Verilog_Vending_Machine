// File: debug/tb/tb_output_asserts.sv

module tb_output_asserts;
  reg clk = 0;
  reg rst_n = 0;

  // Clock generation
  always #5 clk = ~clk;

  interface_output #(.CHANGE_WIDTH(8)) out_if(.clk_i(clk), .rst_ni(rst_n));

  // ========================================================
  // TASKS TO DRIVE THE BUS WITHOUT FALSE ERRORS
  // ========================================================
  task out_idle();
    out_if.alarm_o   <= 0;
    out_if.success_o <= 0;
    out_if.change_o  <= 8'h00;
  endtask

  // ========================================================
  // MAIN TEST SCENARIO
  // ========================================================
  initial begin
    out_idle();
    rst_n = 0;
    #15 rst_n = 1;

    // ---------------------------------------------------------
    // RUN PASS SCENARIOS
    // ---------------------------------------------------------
    $display("\n=== RUNNING PASS SCENARIOS ===");
    
    // Pass 1: Success active, no alarm
    @(posedge clk);
    out_if.alarm_o   <= 0;
    out_if.success_o <= 1;
    out_if.change_o  <= 8'h05;
    @(posedge clk);
    out_idle();

    // Pass 2: Alarm active, no success
    @(posedge clk);
    out_if.alarm_o   <= 1;
    out_if.success_o <= 0;
    out_if.change_o  <= 8'h00;
    @(posedge clk);
    out_idle();

    // ---------------------------------------------------------
    // RUN FAIL SCENARIOS
    // ---------------------------------------------------------
    $display("\n=== RUNNING FAIL SCENARIOS ===");

    // FAIL 1: Alarm and Success active simultaneously
    $display("- Forcing FAIL 1: alarm_success_mutex");
    @(posedge clk);
    out_if.alarm_o   <= 1;
    out_if.success_o <= 1; // ERROR: Both HIGH
    out_if.change_o  <= 8'h00;
    @(posedge clk);
    out_idle();
    @(posedge clk);

    // FAIL 2: Output control signals unknown (X)
    $display("- Forcing FAIL 2: output_controls_known");
    @(posedge clk);
    out_if.alarm_o   <= 1'bx; // ERROR: Driving X on control line
    out_if.success_o <= 0;
    out_if.change_o  <= 8'h00;
    @(posedge clk);
    out_idle();
    @(posedge clk);

    // FAIL 3: Change value unknown (X)
    $display("- Forcing FAIL 3: change_known");
    @(posedge clk);
    out_if.alarm_o   <= 0;
    out_if.success_o <= 1;
    out_if.change_o  <= 8'hxx; // ERROR: Driving X on change_o
    @(posedge clk);
    out_idle();
    @(posedge clk);

    // Finish simulation
    #20;
    $display("\n--- SIMULATION FINISHED ---");
    $finish;
  end
endmodule