# EXECUTIE PATH ABSOLUT (Exemple):
# Windows: & "C:\questasim64_2021.1\win64\vsim.exe" -c -do questa_sim_output_interface.do

# Initializare mediu de lucru
vlib work

# Compilare exclusiva pentru componentele Output si testul asociat
vlog ../../hdl/vending_machine.v
vlog ../tb/interface_output.sv
vlog ../tb/tb_output_asserts.sv

# Instantiere simulator cu drepturi de acces la semnalele interne
vsim -voptargs="+acc" tb_output_asserts

# Extragere ierarhica a semnalelor in fereastra de unda
add wave -r /*

# Executie completa
run -all