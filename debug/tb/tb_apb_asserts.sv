module tb_apb_asserts;
  reg clk = 0;
  reg rst_n = 0;
  
  always #5 clk = ~clk;
  
  interface_APB apb_if(.clk_i(clk), .rst_ni(rst_n));
  
  initial begin
    rst_n = 1;
    apb_if.psel_i = 0;
    apb_if.penable_i = 0;
    apb_if.paddr_i = 8'h00;
    apb_if.pwdata_i = 8'h00;
    
    #15;
    
    // --- TEST ASSERTION 1 (e.g., paddr_stable) ---
    // Pass scenario 1
    @(posedge clk);
    apb_if.psel_i = 1;
    apb_if.paddr_i = 8'hA1;
    @(posedge clk);
    apb_if.paddr_i = 8'hA1; 
    
    // Fail scenario 1
    @(posedge clk);
    apb_if.psel_i = 1;
    apb_if.paddr_i = 8'hB2;
    @(posedge clk);
    apb_if.paddr_i = 8'hC3; 
    
    // --- BUS RESET ---
    @(posedge clk);
    apb_if.psel_i = 0;
    apb_if.penable_i = 0;
    #15;

    // --- TEST ASSERTION 2 (e.g., pwdata_stable on write) ---

    // Pass scenario 2
    @(posedge clk);
    apb_if.psel_i = 1;
    apb_if.pwrite_i = 1;
    apb_if.pwdata_i = 8'hFF;
    @(posedge clk);
    apb_if.penable_i = 1;
    apb_if.pwdata_i = 8'hFF; // pwdata_i stability
    
    // Fail scenario 2
    @(posedge clk);
    apb_if.psel_i = 0;
    apb_if.penable_i = 0;
    @(posedge clk);
    apb_if.psel_i = 1;
    apb_if.pwrite_i = 1;
    apb_if.pwdata_i = 8'hAA;
    @(posedge clk);
    apb_if.penable_i = 1;
    apb_if.pwdata_i = 8'hBB; // Forced pwdata_i instability

    #10 $finish;
  end
endmodule