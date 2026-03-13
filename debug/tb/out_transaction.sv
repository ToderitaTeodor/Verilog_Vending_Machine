//-------------------------------------------------------------------------
//						www.verificationguide.com 
//-------------------------------------------------------------------------
//DOAR SEMNALELE DE IESIRE
//aici se declara tipul de data folosit pentru a stoca datele vehiculate intre generator si driver; monitorul, de asemenea, preia datele de pe interfata, le recompune folosind un obiect al acestui tip de data, si numai apoi le proceseaza
class out_transaction;
  //se declara atributele clasei
  //campurile declarate cu cuvantul cheie rand vor primi valori aleatoare la aplicarea functiei randomize()
  rand bit 			trans_ok;
  rand bit [8-1:0]  change;
  rand bit 		 	alarm;
  
  //constrangerile reprezinta un tip de membru al claselor din SystemVerilog, pe langa atribute si metode
  //aceasta constrangere specifica faptul ca se executa fie o scriere, fie o citire
  //constrangerile sunt aplicate de catre compilator atunci cand atributele clasei primesc valori aleatoare in urma folosirii functiei randomize
 //constraint wr_rd_c { wr_en != rd_en; }; 
  
    // constraint wdata_c;
  
  //aceasta functie este apelata dupa aplicarea functiei randomize() asupra obiectelor apartinand acestei clase
  //aceasta functie afiseaza valorile aleatorizate ale atributelor clasei
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    //$display("\t addr  = %0h",addr);
    if(trans_ok) $display("\t change  = %0h\t alarm = %0h",change,alarm);
    $display("-----------------------------------------");
  endfunction
  
  //operator de copiere a unui obiect intr-un alt obiect (deep copy)
  function out_transaction do_copy();
    out_transaction trans;
    trans = new();
    trans.trans_ok = this.trans_ok;
    trans.change = this.change;
    trans.alarm = this.alarm;
    return trans;
  endfunction
endclass