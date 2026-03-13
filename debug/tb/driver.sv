//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
`define DRIV_IF apb_vif.DRIVER.driver_cb
class driver;
  int no_transactions;
  
  virtual interface_APB apb_vif;
  
  mailbox gen2driv;
  
  function new(virtual interface_APB apb_vif, mailbox gen2driv); 
    this.apb_vif = apb_vif;
    this.gen2driv = gen2driv;
  endfunction
  
  task reset;
    wait(apb_vif.reset);
    $display("--------- [DRIVER] Reset Started ---------");
    `DRIV_IF.wr_en <= 0;
    `DRIV_IF.rd_en <= 0;
    `DRIV_IF.addr  <= 0;
    `DRIV_IF.wdata <= 0;        
    wait(!apb_vif.reset);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  
  task drive;
      transaction trans;
      
     wait(apb_vif.reset);
    
      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
      @(posedge apb_vif.clk);
        `DRIV_IF.addr <= trans.addr;
      if(trans.wr_en) begin
        `DRIV_IF.wr_en <= trans.wr_en;
        `DRIV_IF.wdata <= trans.wdata;
        $display("\tADDR = %0h \tWDATA = %0h",trans.addr,trans.wdata);
        @(posedge apb_vif.clk);
      end
      if(trans.rd_en) begin
        `DRIV_IF.rd_en <= trans.rd_en;
        @(posedge apb_vif.clk);
        `DRIV_IF.rd_en <= 0;
        @(posedge apb_vif.clk);
        trans.rdata = `DRIV_IF.rdata;
        $display("\tADDR = %0h \tRDATA = %0h",trans.addr,`DRIV_IF.rdata);
      end
      $display("-----------------------------------------");
      no_transactions++;
  endtask
  
  task main;
    forever begin
      fork
        begin
          wait(!apb_vif.reset);
        end
        begin
          forever
            drive();
        end
      join_any
      disable fork;
    end
  endtask
        
endclass