//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
//apb_monitorul urmareste traficul de pe interfetele DUT-ului, preia datele verificate si recompune tranzactiile (folosind obiecte ale clasei transaction); in implementarea de fata, datele preluate de pe interfete sunt trimise scoreboardului pentru verificare
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

//in macro-ul MON_IF se retine blocul de semnale de unde apb_monitorul extrage datele
`define MON_IF apb_vif.monitor_cb
class apb_monitor;
  
  //creating virtual interface handle
  virtual interface_APB apb_vif;
  
  //coverage collector 
  apb_coverage cov_collector;
  
  
  //se creaza portul prin care apb_monitorul trimite scoreboardului datele colectate de pe interfata DUT-ului sub forma de tranzactii 
  //creating mailbox handle
  mailbox mon2scb;
  
  //cand se creaza obiectul de tip apb_monitor (in fisierul environment.sv), interfata de pe care acesta colecteaza date este conectata la interfata reala a DUT-ului
  //constructor
  function new(virtual interface_APB apb_vif, mailbox mon2scb);
    //instantierea 
    cov_collector = new (); 
    //getting the interface
    this.apb_vif = apb_vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      //se declara si se creaza obiectul de tip tranzactie care va contine datele preluate de pe interfata
      input_apb_transaction trans;
      trans = new();

      //datele sunt citite pe frontul de ceas, informatiile preluate de pe semnale fiind retinute in oboiectul de tip tranzactie
      
      while (`MON_IF.psel_i == 0 && `MON_IF.penable_i == 0 ) begin
         @(posedge apb_vif.clk_i);
        trans.delay_between_transaction++;
    end
     // TASK: trebuie sa detectyez cand a venit o tranzactie pe protocolul apb, trebuie sa ////
	  trans.addr   = `MON_IF.paddr_i;
      trans.pwrite = `MON_IF.pwrite_i;
	  if(`MON_IF.pwrite_i)
        trans.data = `MON_IF.pwdata_i;
      else
        trans.data = `MON_IF.prdata_o;

      //valorile datelro de pe interfata sunt inregistrate
      cov_collector.sample(trans);
     
      // dupa ce s-au retinut informatiile referitoare la o tranzactie, continutul obiectului trans se trimite catre scoreboard
        mon2scb.put(trans);
    end
  endtask
  
endclass