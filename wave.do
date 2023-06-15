onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -radix hexadecimal -divider {TOP}
add wave -noupdate /tb/DUT/data_i
add wave -noupdate /tb/DUT/reset
add wave -noupdate /tb/DUT/clock
add wave -noupdate /tb/DUT/EA
add wave -noupdate /tb/DUT/start
add wave -noupdate /tb/DUT/i
add wave -noupdate /tb/DUT/j
add wave -noupdate /tb/DUT/atrasoi
add wave -noupdate /tb/DUT/enc_count
add wave -noupdate /tb/DUT/dec_count
add wave -noupdate /tb/DUT/key_count
add wave -noupdate /tb/DUT/MSB
add wave -noupdate /tb/DUT/LSB
add wave -noupdate /tb/DUT/data_o
add wave -noupdate /tb/DUT/ready_o
add wave -noupdate /tb/DUT/busy_o
add wave -noupdate /tb/DUT/integerJ
add wave -noupdate /tb/DUT/CM1
add wave -noupdate /tb/DUT/CM1aux
add wave -noupdate /tb/DUT/Ni
add wave -noupdate /tb/DUT/NiValor
add wave -noupdate /tb/DUT/maskaux
add wave -noupdate /tb/DUT/mask
add wave -noupdate /tb/DUT/integerJ2
add wave -noupdate /tb/DUT/NiValor2
add wave -noupdate /tb/DUT/sbox
add wave -noupdate /tb/DUT/shift11
add wave -noupdate /tb/DUT/CM2
add wave -noupdate /tb/DUT/keyaux



TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {600 ns}