# EXECUTIE PATH ABSOLUT (Exemple):
# Windows: & "C:\questasim64_2021.1\win64\vsim.exe" -c -do questa_sim.do

# Initializarea bibliotecii de lucru 
#vlib work

# Compilarea tuturor fisierelor de vending machine (hdl) 
vlog ../../hdl/*.v

# doar daca exista fisiere .sv folosim comanda
# vlog ../../hdl/*.sv 

# Compilarea fisierelor de testbench cu adaugarea cailor de includere pentru macro-uri 
vlog +incdir+../tb +incdir+../tests ../tb/testbench.sv 

# Incarcarea modulului de top in simulator (optimizarea de vizibilitate +acc activata) 
vsim -voptargs="+acc" testbench 

# Deschiderea ferestrei cu forme de unda (necesar doar in mod GUI) 
# add wave -r /* 

# Rularea simularii pana la instructiunea $finish 
run -all 

# Mod consola: vsim -c -do questa_sim.do 