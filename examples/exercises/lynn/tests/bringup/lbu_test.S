// RV32I Test Suite
// lbu_test.S
// Using data section

.extern return_lbu_test
.extern fail

.section .text.init
.globl lbu_test
.type lbu_test, @function

lbu_test:
test1:
    la t4, test_data_lbu
    li t0, 0x12345678
    sw t0, 0(t4)
    lbu t1, 0(t4)
    li t2, 0x78
    beq t1, t2, test2
    j Fail_LBU_1

test2:
    la t4, test_data_lbu
    li t0, 0x000000FF
    sw t0, 0(t4)
    lbu t1, 0(t4)
    li t2, 0xFF
    beq t1, t2, test3
    j Fail_LBU_2

test3:
    la t4, test_data_lbu
    li t0, 0x12345678
    sw t0, 0(t4)
    lbu t1, 2(t4)
    li t2, 0x34
    beq t1, t2, pass
    j Fail_LBU_3

pass:
    j return_lbu_test

Fail_LBU_1:
    li gp, 641
    j fail

Fail_LBU_2:
    li gp, 642
    j fail

Fail_LBU_3:
    li gp, 643
    j fail

.section .data
.align 4
test_data_lbu:
    .word 0
