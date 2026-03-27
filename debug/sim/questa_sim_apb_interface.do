# EXECUTIE PATH ABSOLUT (Exemple):
# Windows: & "C:\questasim64_2021.1\win64\vsim.exe" -c -do questa_sim_apb_interface.do

# Initializare mediu de lucru
vlib work

# Compilare exclusiva pentru componentele APB si testul asociat
vlog ../../hdl/apb_protocol.v
vlog ../tb/interface_APB.sv
vlog ../tb/tb_apb_asserts.sv

# Instantiere simulator cu drepturi de acces la semnalele interne
vsim -voptargs="+acc" tb_apb_asserts

# Extragere ierarhica a semnalelor in fereastra de unda
add wave -r /*

# Executie completa
run -all