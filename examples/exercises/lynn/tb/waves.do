# riscvsingle_waves.do

# Top-level processor ports
add wave -divider "--- TOP ---"
add wave sim:/testbench/dut/clk
add wave sim:/testbench/dut/reset
add wave -radix hex sim:/testbench/dut/PC
add wave -radix hex sim:/testbench/dut/Instr
add wave -radix hex sim:/testbench/dut/IEUAdr
add wave -radix hex sim:/testbench/dut/ReadData
add wave -radix hex sim:/testbench/dut/WriteData
add wave      sim:/testbench/dut/MemEn
add wave      sim:/testbench/dut/WriteEn
add wave -radix bin  sim:/testbench/dut/WriteByteEn

# IFU
add wave -divider "--- IFU ---"
add wave -radix hex sim:/testbench/dut/ifu/PCNext
add wave -radix hex sim:/testbench/dut/ifu/PCPlus4
add wave      sim:/testbench/dut/ifu/PCSrc

# Controller
add wave -divider "--- CONTROLLER ---"
add wave -radix hex  sim:/testbench/dut/ieu/c/Op
add wave -radix hex  sim:/testbench/dut/ieu/c/Funct3
add wave      sim:/testbench/dut/ieu/c/Funct7b5
add wave -radix bin  sim:/testbench/dut/ieu/c/ALUControl
add wave -radix bin  sim:/testbench/dut/ieu/c/ALUSrc
add wave -radix bin  sim:/testbench/dut/ieu/c/ImmSrc
add wave      sim:/testbench/dut/ieu/c/RegWrite
add wave      sim:/testbench/dut/ieu/c/MemWrite
add wave      sim:/testbench/dut/ieu/c/ResultSrc
add wave      sim:/testbench/dut/ieu/c/ALUResultSrc
add wave      sim:/testbench/dut/ieu/c/Branch
add wave      sim:/testbench/dut/ieu/c/Jump
add wave      sim:/testbench/dut/ieu/c/ConditionMet

# Datapath
add wave -divider "--- DATAPATH ---"
add wave -radix hex sim:/testbench/dut/ieu/dp/RD1
add wave -radix hex sim:/testbench/dut/ieu/dp/RD2
add wave -radix hex sim:/testbench/dut/ieu/dp/ImmExt
add wave -radix hex sim:/testbench/dut/ieu/dp/SrcA
add wave -radix hex sim:/testbench/dut/ieu/dp/SrcB
add wave -radix hex sim:/testbench/dut/ieu/dp/ALUResult
add wave -radix hex sim:/testbench/dut/ieu/dp/IEUAdr
add wave -radix hex sim:/testbench/dut/ieu/dp/WriteData
add wave -radix hex sim:/testbench/dut/ieu/dp/LoadData
add wave -radix hex sim:/testbench/dut/ieu/dp/Result
add wave      sim:/testbench/dut/ieu/dp/Eq
add wave      sim:/testbench/dut/ieu/dp/LT
add wave      sim:/testbench/dut/ieu/dp/LTU

configure wave -timelineunits ns
WaveRestoreZoom {0} {500ns}
