vsim work.intermediatebuffer
add wave -position insertpoint  \
sim:/intermediatebuffer/BRANCH \
sim:/intermediatebuffer/CLK \
sim:/intermediatebuffer/D \
sim:/intermediatebuffer/EN \
sim:/intermediatebuffer/HAZARDDETECT \
sim:/intermediatebuffer/INT \
sim:/intermediatebuffer/N \
sim:/intermediatebuffer/Q \
sim:/intermediatebuffer/RET \
sim:/intermediatebuffer/RST \
sim:/intermediatebuffer/RTI
force -freeze sim:/intermediatebuffer/CLK 1 0, 0 {10 ns} -r 20
force -freeze sim:/intermediatebuffer/D 32'hFFFFFFFF 0
force -freeze sim:/intermediatebuffer/EN 1 0
force -freeze sim:/intermediatebuffer/RST 0 0
run
force -freeze sim:/intermediatebuffer/RST 1 0
run
force -freeze sim:/intermediatebuffer/RST 0 0
force -freeze sim:/intermediatebuffer/EN 0 0
run
force -freeze sim:/intermediatebuffer/EN 1 0
run

