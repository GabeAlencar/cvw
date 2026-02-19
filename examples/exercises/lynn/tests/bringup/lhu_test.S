// RV32I Test Suite
// lhu_test.S
// Using data section

.extern return_lhu_test
.extern fail

.section .text.init
.globl lhu_test
.type lhu_test, @function

lhu_test:
test1:
    la t4, test_data_lhu
    li t0, 0x12345678
    sw t0, 0(t4)
    lhu t1, 0(t4)
    li t2, 0x5678
    beq t1, t2, test2
    j Fail_LHU_1

test2:
    la t4, test_data_lhu
    li t0, 0x0000FFFF
    sw t0, 0(t4)
    lhu t1, 0(t4)
    li t2, 0xFFFF
    beq t1, t2, test3
    j Fail_LHU_2

test3:
    la t4, test_data_lhu
    li t0, 0x12348678
    sw t0, 0(t4)
    lhu t1, 2(t4)
    li t2, 0x1234
    beq t1, t2, pass
    j Fail_LHU_3

pass:
    j return_lhu_test

Fail_LHU_1:
    li gp, 661
    j fail

Fail_LHU_2:
    li gp, 662
    j fail

Fail_LHU_3:
    li gp, 663
    j fail

.section .data
.align 4
test_data_lhu:
    .word 0
