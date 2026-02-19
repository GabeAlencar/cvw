// RV32I Test Suite
// sb_test.S
// Using data section

.extern return_sb_test
.extern fail

.section .text.init
.globl sb_test
.type sb_test, @function

sb_test:
test1:
    la t4, test_data_sb
    li t0, 0xFFFFFFFF
    sw t0, 0(t4)
    li t1, 0xAB
    sb t1, 0(t4)
    lw t2, 0(t4)
    li t3, 0xFFFFFFAB
    beq t2, t3, test2
    j Fail_SB_1

test2:
    la t4, test_data_sb
    li t0, 0x00000000
    sw t0, 0(t4)
    li t1, 0x12345678
    sb t1, 1(t4)
    lw t2, 0(t4)
    li t3, 0x00007800
    beq t2, t3, test3
    j Fail_SB_2

test3:
    la t4, test_data_sb
    li t0, 0x00000000
    sw t0, 0(t4)
    li t1, 0xFF
    sb t1, 3(t4)
    lw t2, 0(t4)
    li t3, 0xFF000000
    beq t2, t3, pass
    j Fail_SB_3

pass:
    j return_sb_test

Fail_SB_1:
    li gp, 671
    j fail

Fail_SB_2:
    li gp, 672
    j fail

Fail_SB_3:
    li gp, 673
    j fail

.section .data
.align 4
test_data_sb:
    .word 0
