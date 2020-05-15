vsim work.datamemory

add wave -position insertpoint  \
sim:/datamemory/MemRead \
sim:/datamemory/MemWrite \
sim:/datamemory/address \
sim:/datamemory/clk \
sim:/datamemory/datain \
sim:/datamemory/dataout \
sim:/datamemory/ram \
sim:/datamemory/reset
mem load -filltype value -filldata 0000 -fillradix hexadecimal /datamemory/ram(0)
mem load -filltype value -filldata 1111 -fillradix hexadecimal /datamemory/ram(1)

mem load -filltype value -filldata 1111 -fillradix hexadecimal /datamemory/ram(1)
mem load -filltype value -filldata 2222 -fillradix hexadecimal /datamemory/ram(2)
mem load -filltype value -filldata {3333 } -fillradix hexadecimal /datamemory/ram(3)
mem load -filltype value -filldata {4444 } -fillradix hexadecimal /datamemory/ram(4)
mem load -filltype value -filldata {5555 } -fillradix hexadecimal /datamemory/ram(5)
force -freeze sim:/datamemory/MemRead 1 0
force -freeze sim:/datamemory/MemWrite 0 0
force -freeze sim:/datamemory/address 20'h00004 0
force -freeze sim:/datamemory/clk 1 0, 0 {10 ns} -r 20
force -freeze sim:/datamemory/reset 0 0
run
force -freeze sim:/datamemory/MemWrite 1 0
force -freeze sim:/datamemory/MemRead 0 0
force -freeze sim:/datamemory/address 20'h00006 0
force -freeze sim:/datamemory/datain 32'hFFFF1111 0
run
force -freeze sim:/datamemory/reset 1 0
run