//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------

//in mediul de verificare se instantiaza toate componentele de verificare
`include "transaction.sv"
`include "out_transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "out_monitor.sv"
`include "coverage.sv"
`include "scoreboard.sv"
class environment;
  
  //componentele de verificare sunt declarate
  //generator and driver instance
  generator  gen;
  driver     driv;
  monitor    mon;
  scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //event for synchronization between generator and test
  event gen_ended;
  
 //virtual interface
  virtual interface_output out_vif;
  virtual interface_APB    apb_vif; // Adăugat pentru driver
  
  //constructor
  function new(virtual interface_output out_vif, virtual interface_APB apb_vif);
    //get the interface from test
    this.out_vif = out_vif;
    this.apb_vif = apb_vif; // Maparea noii interfețe
    
    //creating the mailbox
    gen2driv = new();
    mon2scb  = new();
    
    //creating generator and driver
    gen  = new(gen2driv,gen_ended);
    driv = new(apb_vif,gen2driv); // Conectăm APB la Driver
    mon  = new(out_vif,mon2scb);  // Conectăm Output la Monitor
    scb  = new(mon2scb);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    //se urmareste ca toate datele generate sa fie transmise la DUT si sa ajunga si la scoreboard
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
  endtask  
  
  function report();
    scb.colector_coverage.print_coverage();
  endfunction
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    report();
    //linia de mai jos este necesara pentru ca simularea sa sa termine
    $finish;
  endtask
  
endclass

