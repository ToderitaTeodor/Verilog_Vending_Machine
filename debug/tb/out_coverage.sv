//prin coverage, putem vedea ce situatii (de exemplu, ce tipuri de tranzactii) au fost generate in simulare; astfel putem masura stadiul la care am ajuns cu verificarea
class out_coverage;
  
  out_transaction out_trans_covered;
  
  //pentru a se putea vedea valoarea de coverage pentru fiecare element trebuie create mai multe grupuri de coverage, sau trebuie creata o functie de afisare proprie
  covergroup out_transaction_cg;
    //linia de mai jos este adaugata deoarece, daca sunt mai multe instante pentru care se calculeaza coverage-ul, noi vrem sa stim pentru fiecare dintre ele, separat, ce valoare avem.
    option.per_instance = 1;
    success_enable_cp: 	coverpoint out_trans_covered.success;
    alarm_enable_cp: 	coverpoint out_trans_covered.alarm;
    
    // adaugati adresele tuturor registrilor pe care ii aveti in DUT (sunt documentati in specificatie)
   
    
    write_data_cp: coverpoint out_trans_covered.change {
      bins big_values 		= {[191:254]};
      bins medium_values 	= {[127:190]};
      bins low_values		= {[1:126]};
      bins lowest_value 	= {0};
      bins highest_value 	= {255};
    }
    
  endgroup
  //se creaza grupul de coverage; ATENTIE! Fara functia de mai jos, grupul de coverage nu va putea esantiona niciodata date deoarece pana acum el a fost doar declarat, nu si creat
  function new();
    out_transaction_cg = new();
  endfunction
  
  task sample(out_transaction out_trans_covered); 
  	this.out_trans_covered = out_trans_covered; 
  	out_transaction_cg.sample(); 
  endtask:sample   
  
  function print_coverage();
    $display ("Success coverage = %.2f%%", out_transaction_cg.success_enable_cp.get_coverage());
    $display ("Alarm coverage = %.2f%%", out_transaction_cg.alarm_enable_cp.get_coverage());
    $display ("Change coverage = %.2f%%", out_transaction_cg.write_data_cp.get_coverage());
  endfunction
  
  //o alta modalitate de a incheia declaratia unei clase este sa se scrie "endclass: numele_clasei"; acest lucru este util mai ales cand se declara mai multe clase in acelasi fisier; totusi, se recomanda ca fiecare fisier sa nu contina mai mult de o declaratie a unei clase
endclass: out_coverage

