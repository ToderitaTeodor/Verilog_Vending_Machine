# EXECUTIE PATH ABSOLUT (Exemple):
# Windows: & "C:\questasim64_2021.1\win64\vsim.exe" -c -do questa_sim.do

# Initializarea bibliotecii de lucru 
vlib work

# Compile all HDL files
vlog ../../hdl/*.v

# Compile the specific test you want to run (e.g., default_rd_test.sv)
# This provides the "program test" definition
vlog +incdir+../tb ../tests/default_rd_test.sv

# Compile the testbench top with include directories for components
vlog +incdir+../tb +incdir+../tests ../tb/testbench.sv

# Run simulation
vsim -voptargs="+acc" testbench 

# Run until $finish
run -all