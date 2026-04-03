//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------
//monitorul urmareste traficul de pe interfetele DUT-ului, preia datele verificate si recompune tranzactiile (folosind obiecte ale clasei transaction); in implementarea de fata, datele preluate de pe interfete sunt trimise scoreboardului pentru verificare
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

//in macro-ul MON_OUT se retine blocul de semnale de unde monitorul extrage datele
`define MON_OUT out_intf.MONITOR.monitor_cb
class out_monitor;
  
  //creating virtual interface handle
  virtual interface_output out_intf; // Modificat din mem_intf
  
  out_coverage out2cov;
  
  //se creaza portul prin care monitorul trimite scoreboardului datele colectate de pe interfata DUT-ului sub forma de tranzactii 
  //creating mailbox handle
  mailbox out_mon2scb;
  
  //cand se creaza obiectul de tip monitor (in fisierul environment.sv), interfata de pe care acesta colecteaza date este conectata la interfata reala a DUT-ului
  //constructor
  function new(virtual interface_output out_intf, mailbox out_mon2scb); // Modificat din mem_intf
    //getting the interface
    this.out_intf = out_intf;
    //getting the mailbox handles from  environment 
    this.out_mon2scb = out_mon2scb;
    // construieste obiectul de coverage
    //this.out_mon2scb = out_mon2scb;
    out2cov = new();
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      //se declara si se creaza obiectul de tip tranzactie care va contine datele preluate de pe interfata
      out_transaction trans;
      trans = new();

      //datele sunt citite pe frontul de ceas, informatiile preluate de pe semnale fiind retinute in oboiectul de tip tranzactie
      @(posedge out_intf.MONITOR.clk_i);
      trans.alarm 	= `MON_OUT.alarm_o;
      trans.success = `MON_OUT.success_o;
	  trans.change 	= `MON_OUT.change_o;   
      // dupa ce s-au retinut informatiile referitoare la o tranzactie, continutul obiectului trans se trimite catre scoreboard
      out_mon2scb.put(trans);
      // esantionare coverage pentru tranzactia curenta
      out2cov.sample(trans);
    end
  endtask
  
endclass