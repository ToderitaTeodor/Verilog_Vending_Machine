//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------

//in mediul de verificare se instantiaza toate componentele de verificare
`include "input_apb_transaction.sv"
`include "out_transaction.sv"
`include "apb_generator.sv"
`include "apb_driver.sv"
`include "apb_coverage.sv"
`include "apb_monitor.sv"
`include "out_coverage.sv"
`include "out_monitor.sv" 
//`include "scoreboard.sv"
class environment;
  
  //componentele de verificare sunt declarate
  //generator and driver instance
  apb_generator  apb_gen;
  apb_driver     apb_driv;
  apb_monitor    apb_mon;
  out_monitor	 out_mon;
  //scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox apb_mon2scb;
  mailbox out_mon2scb;
  
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
    apb_mon2scb  = new();
    out_mon2scb  = new();
    
    //creating generator and driver
    apb_gen  = new(gen2driv,gen_ended);
    apb_driv  = new(apb_vif,gen2driv); 		// Conectăm APB la Driver
    apb_mon  = new(out_vif,apb_mon2scb);  	// Conectăm Output la Monitor
    //scb  = new(apb_mon2scb);
  endfunction
  
  //
  task pre_test();
    apb_driv.reset();
  endtask
  
  task test();
    fork 
    apb_gen.main();
    apb_driv.main();
    apb_mon.main();
    out_mon.main();
    //scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    //se urmareste ca toate datele generate sa fie transmise la DUT si sa ajunga si la scoreboard
//    wait(apb_gen.repeat_count == apb_gen.no_transactions);
//    wait(apb_gen.repeat_count == scb.no_transactions);
    #4000;
  endtask  
  
  function report();
 //   scb.colector_coverage.print_coverage();
  endfunction
  
  //run task
  task run;
    pre_test();
	$stop;
    test();
    post_test();
    report();
    //linia de mai jos este necesara pentru ca simularea sa sa termine
    $finish;
  endtask
  
endclass

