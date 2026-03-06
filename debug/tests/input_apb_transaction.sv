//-------------------------------------------------------------------------
//						www.verificationguide.com 
//-------------------------------------------------------------------------

//aici se declara tipul de data folosit pentru a stoca datele vehiculate intre generator si driver; monitorul, de asemenea, preia datele de pe interfata, le recompune folosind un obiect al acestui tip de data, si numai apoi le proceseaza
class input_apb_transactions;
  //se declara atributele clasei
  //campurile declarate cu cuvantul cheie rand vor primi valori aleatoare la aplicarea functiei randomize()

  rand bit [7:0] addr;
  rand bit   	 pwrite;
  rand bit [7:0] data;
  rand int delay_between_tranzactions;
  
  
  //constrangerile reprezinta un tip de membru al claselor din SystemVerilog, pe langa atribute si metode
  //aceasta constrangere specifica faptul ca se executa fie o scriere, fie o citire
  //constrangerile sunt aplicate de catre compilator atunci cand atributele clasei primesc valori aleatoare in urma folosirii functiei randomize
  constraint pwrite { delay_between_tranzaction inside [1:20]; 
  
     constraint data
  
  //aceasta functie este apelata dupa aplicarea functiei randomize() asupra obiectelor apartinand acestei clase
  //aceasta functie afiseaza valorile aleatorizate ale atributelor clasei
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    //$display("\t addr  = %0h",addr);
    if(pwrite) $display("\t addr  = %0h\t wr_en = %0h\t wdata = %0h",addr,pwrite,data);
    if(rd_en) $display("\t addr  = %0h\t rd_en = %0h",addr,rd_en);
    $display("-----------------------------------------");
  endfunction
  
  //operator de copiere a unui obiect intr-un alt obiect (deep copy)
  function input_apb_transactions do_copy();
    input_apb_transactions trans;
    trans = new();
    trans.addr   = this.addr;
    trans.pwrite = this.pwrite;
    trans.data   = this.data;
    trans.delay_between_tranzactions = this.delay_between_tranzactions;
    
    return trans;
  endfunction
endclass