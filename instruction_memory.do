vsim work.memory
add wave -position insertpoint  \
sim:/memory/address \
sim:/memory/dataout \
sim:/memory/memory
mem load -filltype value -filldata 5555 -fillradix hexadecimal /memory/memory(0)
mem load -filltype value -filldata 4444 -fillradix hexadecimal /memory/memory(1)
force -freeze sim:/memory/address 7'h00 0
run
force -freeze sim:/memory/address 7'h01 0
run