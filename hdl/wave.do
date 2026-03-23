onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /venindg_machine_tb/DUT_test_bench/clk_i
add wave -noupdate -label rst_n /venindg_machine_tb/DUT_test_bench/rst_ni
add wave -noupdate -divider <NULL>
add wave -noupdate -label PSEL /venindg_machine_tb/DUT_test_bench/psel_i
add wave -noupdate -label PENABLE /venindg_machine_tb/DUT_test_bench/penable_i
add wave -noupdate -label PWRITE /venindg_machine_tb/DUT_test_bench/pwrite_i
add wave -noupdate -label PREADY /venindg_machine_tb/DUT_test_bench/pready_o
add wave -noupdate -divider <NULL>
add wave -noupdate -label PADDR -radix unsigned /venindg_machine_tb/DUT_test_bench/paddr_i
add wave -noupdate -label PWDATA -radix unsigned /venindg_machine_tb/DUT_test_bench/pwdata_i
add wave -noupdate -divider <NULL>
add wave -noupdate -label MONEY_REG -radix unsigned /venindg_machine_tb/DUT_test_bench/money
add wave -noupdate -label ITEM_REG -radix unsigned /venindg_machine_tb/DUT_test_bench/item
add wave -noupdate -label CONTROL_REG -radix unsigned /venindg_machine_tb/DUT_test_bench/control_reg
add wave -noupdate -divider <NULL>
add wave -noupdate -label alarm /venindg_machine_tb/DUT_test_bench/alarm_o
add wave -noupdate -label change -radix unsigned /venindg_machine_tb/DUT_test_bench/change_o
add wave -noupdate -divider <NULL>
add wave -noupdate -label success /venindg_machine_tb/DUT_test_bench/success_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {253552 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 337
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {721920 ps}
