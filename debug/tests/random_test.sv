//-------------------------------------------------------------------------
//						www.verificationguide.com
//-------------------------------------------------------------------------

//tranzactiile din acest text se genereaza complet aleatoriu (singura constrangere fiind in fisierul transaction.sv, aceasta asigurand functionalitatea corecta a DUT-ului)
`include "environment.sv"
program test(interface_output out_intf, interface_APB apb_intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new( out_intf, apb_intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.apb_gen.repeat_count = 4;
   /* 
    env.apb_gen.write_reg(2, 40);
    env.apb_gen.write_reg(2, 40);
    env.apb_gen.write_reg(2, 40);
    */
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram