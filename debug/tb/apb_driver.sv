//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
//apb_driverul preia datele de la generator, la nivel abstract, si le trimite DUT-ului conform protocolului de comunicatie pe interfata respectiva
//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 


//se declara macro-ul DRIV_IF care va reprezenta interfata pe care apb_driverul va trimite date DUT-ului
`define DRIV_IF apb_vif.apb_driver.apb_driver_cb
class apb_driver;
  
  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual interface_APB apb_vif;
  
  //se creaza portul prin care apb_driverul primeste datele la nivel abstract de la DUT
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual interface_APB apb_vif,mailbox gen2driv);
    //cand se creaza apb_driverul, interfata pe care acesta trimite datele este conectata la interfata reala a DUT-ului
    //getting the interface
    this.apb_vif = apb_vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(!apb_vif.reset);
    $display("--------- [apb_driver] Reset Started ---------");
    `DRIV_IF.paddr_i <= 0;
    `DRIV_IF.psel_i <= 0;
    `DRIV_IF.penable_i  <= 0;
    `DRIV_IF.pwrite_i <= 0;
    `DRIV_IF.pwdata_i <= 0;
    wait(apb_vif.reset);
    $display("--------- [apb_driver] Reset Ended ---------");
  endtask
  
  //drives the transaction items to interface signals
  task drive;
      transaction trans;
      
    //se asteapta ca modulul sa iasa din reset
     wait(apb_vif.reset);//linie valabila daca resetul este activ in 0
    //wait(!apb_vif.reset);//linie valabila daca resetul este activ in 1
    
    //daca nu are date de la generator, apb_driverul ramane cu executia la linia de mai jos, pana cand primeste respectivele date
      gen2driv.get(trans);
      $display("--------- [apb_driver-TRANSFER: %0d] ---------",no_transactions);
    repeat(trans.delay_between_transaction)@(posedge apb_vif.apb_driver.clk);
    
// SETUP phase
    `DRIV_IF.paddr_i   <= trans.addr;
    `DRIV_IF.pwrite_i  <= trans.pwrite;
    if (trans.pwrite) // la tranzactia de scriere se pun date pe pwdata
    	`DRIV_IF.pwdata_i  <= trans.data;
    `DRIV_IF.psel_i    <= 1;
    `DRIV_IF.penable_i <= 0;
    
    // ACCESS phase
    @(posedge apb_vif.clk_i);
    `DRIV_IF.penable_i <= 1;
    
    // așteaptă slave ready
    wait(apb_vif.pready_o == 1);
    
    // terminare transfer
    @(posedge apb_vif.clk_i);
    `DRIV_IF.psel_i    <= 0;
    `DRIV_IF.penable_i <= 0;
    
    $display("addr=%0h pwrite=%0b data=%0h delay=%0d",
             trans.addr, trans.pwrite, trans.data, trans.delay_between_transaction);

  no_transactions++;
  endtask
  
    
  //Cele doua fire de executie de mai jos ruleaza in paralel. Dupa ce primul dintre ele se termina al doilea este intrerupt automat. Daca se activeaza reset-ul, nu se mai transmit date. 
  task main;
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          wait(!apb_vif.reset);//linie valabila daca resetul este activ in 0
          //wait(apb_vif.reset);//linie valabila daca resetul este activ in 1
        end
        //Thread-2: Calling drive task
        begin
          //transmiterea datelor se face permanent, dar este conditionta de primirea datelor de la monitor.
          forever
            drive();
        end
      join_any
      disable fork;
        reset(); //daca s a iesit din structura fork-join_any, inseamna ca s-a activat semnalul de reset
    end
  endtask
        
endclass