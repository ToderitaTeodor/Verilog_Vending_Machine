module tb_apb_asserts;
  reg clk = 0;
  reg rst_n = 0;
  
  always #5 clk = ~clk;
  
  interface_APB apb_if(.clk_i(clk), .rst_ni(rst_n));

  // ========================================================
  // TASKS TO DRIVE THE BUS WITHOUT FALSE ERRORS
  // (Using '<=' to simulate real hardware behavior)
  // ========================================================
  task apb_idle();
    apb_if.psel_i    <= 0;
    apb_if.penable_i <= 0;
    apb_if.pready_o  <= 0;
  endtask

  task apb_pass_transfer(input logic [7:0] addr);
    // 1. SETUP PHASE
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.paddr_i   <= addr;
    apb_if.pready_o  <= 0; // Slave hasn't responded yet
    
    // 2. ACCESS PHASE
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.pready_o  <= 1; // Slave finished the transaction
    
    // 3. RETURN TO IDLE (All signals fall cleanly simultaneously)
    @(posedge clk);
    apb_idle();
  endtask

  // ========================================================
  // MAIN TEST SCENARIO
  // ========================================================
  initial begin
    // Clean initial reset, without clock edge
    apb_if.psel_i    = 0;
    apb_if.penable_i = 0;
    apb_if.pready_o  = 0;
    apb_if.paddr_i   = 8'h00;
    
    rst_n = 0;
    #15 rst_n = 1;

    // ---------------------------------------------------------
    // RUN PASS SCENARIOS (Consecutive, should not display errors)
    // ---------------------------------------------------------
    $display("\n=== RUNNING PASS SCENARIOS (UNIFIED) ===");
    
    // Correct transaction 1
    apb_pass_transfer(8'hA1);
    @(posedge clk); // Wait for one idle cycle
    
    // Correct transaction 2
    apb_pass_transfer(8'hB2);
    @(posedge clk); // Wait for one idle cycle

    // ---------------------------------------------------------
    // RUN FAIL SCENARIOS (Triggering errors one by one over time)
    // ---------------------------------------------------------


    // Finish simulation
    #20;
    $display("\n--- SIMULATION FINISHED ---");
    $finish;
  end
endmodule


module tb_apb_asserts;
  reg clk = 0;
  reg rst_n = 0;
  
  // Clock generation
  always #5 clk = ~clk;
  
  interface_APB apb_if(.clk_i(clk), .rst_ni(rst_n));

  // ========================================================
  // TASKS TO DRIVE THE BUS WITHOUT FALSE ERRORS
  // ========================================================
  task apb_idle();
    apb_if.psel_i    <= 0;
    apb_if.penable_i <= 0;
    apb_if.pready_o  <= 0;
    apb_if.pwrite_i  <= 0;
    apb_if.pwdata_i  <= 8'h00;
    apb_if.paddr_i   <= 8'h00;
  endtask

  task apb_pass_write(input logic [7:0] addr, input logic [7:0] data);
    // 1. SETUP PHASE (Write)
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.pwrite_i  <= 1;
    apb_if.paddr_i   <= addr;
    apb_if.pwdata_i  <= data;
    apb_if.pready_o  <= 0; 
    
    // 2. ACCESS PHASE
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.pready_o  <= 1; 
    
    // 3. RETURN TO IDLE
    @(posedge clk);
    apb_idle();
  endtask

  // ========================================================
  // MAIN TEST SCENARIO
  // ========================================================
  initial begin
    apb_idle();
    
    rst_n = 0;
    #15 rst_n = 1;

    // ---------------------------------------------------------
    // RUN PASS SCENARIOS
    // ---------------------------------------------------------
    $display("\n=== RUNNING PASS SCENARIOS ===");
    
    // Correct write transaction
    apb_pass_write(8'hA1, 8'hFF);
    @(posedge clk);
    
    // ---------------------------------------------------------
    // RUN FAIL SCENARIOS
    // ---------------------------------------------------------
    $display("\n=== RUNNING FAIL SCENARIOS ===");

    // FAIL 1: Unstable address in ACCESS phase
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.paddr_i   <= 8'hC3;
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.paddr_i   <= 8'hD4; // ERROR: Address changes illegally!
    apb_if.pready_o  <= 1;
    @(posedge clk);
    apb_idle();
    
    @(posedge clk);

    // FAIL 2: PREADY is HIGH when PSEL is LOW
    @(posedge clk);
    apb_if.pready_o  <= 1; // ERROR: Pready HIGH in IDLE, without active PSEL
    @(posedge clk);
    apb_idle();
    
    @(posedge clk);

    // FAIL 3: PREADY falls, but PENABLE was not 1 (Tests the new past assertion)
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.pready_o  <= 1; // Assert PREADY too early (in SETUP)
    @(posedge clk);
    apb_if.pready_o  <= 0; // ERROR: PREADY falls from 1 to 0, but PENABLE was not activated!
    apb_idle();
    
    @(posedge clk);

    // FAIL 4 & 5: PSEL falls, but PENABLE and PREADY "forget" to fall and stay stuck at 1
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.paddr_i   <= 8'hF6;
    apb_if.pready_o  <= 0;
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.pready_o  <= 1;
    @(posedge clk);
    apb_if.psel_i    <= 0; // PSEL falls at the end of transfer...
    apb_if.penable_i <= 1; // ERROR: Master forgets to lower penable!
    apb_if.pready_o  <= 1; // ERROR: Slave forgets to lower pready!
    @(posedge clk);
    apb_idle();
    @(posedge clk);
    
    // FAIL 6: PWRITE unstable in ACCESS phase
    $display("- Forcing FAIL 6: pwrite unstable");
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.pwrite_i  <= 1; // Setup as Write
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.pwrite_i  <= 0; // ERROR: Direction changed to Read in ACCESS!
    apb_if.pready_o  <= 1;
    @(posedge clk);
    apb_idle();
    @(posedge clk);

    // FAIL 7: PWDATA unstable in ACCESS phase
    $display("- Forcing FAIL 7: pwdata unstable");
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    apb_if.pwrite_i  <= 1;
    apb_if.pwdata_i  <= 8'hAA;
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.pwdata_i  <= 8'hBB; // ERROR: Data changed during ACCESS!
    apb_if.pready_o  <= 1;
    @(posedge clk);
    apb_idle();
    @(posedge clk);

    // FAIL 8: SETUP ran for more than one cycle
    $display("- Forcing FAIL 8: setup > 1 cycle");
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0; // Cycle 1 of SETUP
    @(posedge clk);
    apb_if.penable_i <= 0; // ERROR: Cycle 2 of SETUP (should be ACCESS)
    @(posedge clk);
    apb_idle();
    @(posedge clk);

    // FAIL 9: Control signals are UNKNOWN (X)
    $display("- Forcing FAIL 9: unknown control signals");
    @(posedge clk);
    apb_if.psel_i <= 1'bx; // ERROR: Driving an 'X' on a control line
    @(posedge clk);
    apb_idle();
    @(posedge clk);

    // FAIL 10: PREADY Timeout (Watchdog)
    $display("- Forcing FAIL 10: pready timeout");
    @(posedge clk);
    apb_if.psel_i    <= 1;
    apb_if.penable_i <= 0;
    @(posedge clk);
    apb_if.penable_i <= 1;
    apb_if.pready_o  <= 0; // Slave asks for wait states
    
    // Wait for 17 cycles to trigger the 16-cycle watchdog error
    repeat(17) @(posedge clk); 
    
    apb_if.pready_o <= 1; // Finally answers
    @(posedge clk);
    apb_idle();

    // Finish simulation
    #20;
    $display("\n--- SIMULATION FINISHED ---");
    $finish;
  end
endmodule