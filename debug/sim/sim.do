# Initializarea bibliotecii de lucru
#vlib work

# Compilarea fisierelor de design (hdl)
vlog ../../hdl/design.sv

# Compilarea fisierelor de testbench cu adaugarea cailor de includere pentru macro-uri
vlog +incdir+../tb +incdir+../tests ../tb/testbench.sv

# Incarcarea modulului de top in simulator (optimizarea de vizibilitate +acc activata)
vsim -voptargs="+acc" testbench

# Deschiderea ferestrei cu forme de unda si adaugarea tuturor semnalelor ierarhiei curente (necesar doar in mod GUI)
# add wave -r /*

# Rularea simularii pana la instructiunea $finish
run -all



#Mod consolă (execuție rapidă, fără interfață grafică):
#vsim -c -do sim.do

#Mod grafic (pentru analiză pe forme de undă):
#vsim -do sim.do