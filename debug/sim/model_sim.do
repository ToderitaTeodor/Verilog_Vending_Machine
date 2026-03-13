# EXECUTIE PATH ABSOLUT (Exemple):
# Windows: & "C:\intelFPGA\20.1\modelsim_ase\win32aloem\vsim.exe" -c -do model_sim.do

# Initializarea bibliotecii de lucru 
#vlib work 

# Compilarea fisierelor de design (hdl) 
vlog ../../hdl/design.sv 

# Compilarea fisierelor de testbench cu adaugarea cailor de includere pentru macro-uri 
vlog +incdir+../tb +incdir+../tests ../tb/testbench.sv 

# Incarcarea modulului de top in simulator (optimizarea de vizibilitate +acc activata) 
vsim -voptargs="+acc" testbench 

# Deschiderea ferestrei cu forme de unda (necesar doar in mod GUI) 
# add wave -r /* 

# Rularea simularii pana la instructiunea $finish 
run -all 

# Mod consola: vsim -c -do model_sim.do 