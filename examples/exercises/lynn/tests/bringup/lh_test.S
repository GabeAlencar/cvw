// RV32I Test Suite
// lh_test.S
// Using data section

.extern return_lh_test
.extern fail

.section .text.init
.globl lh_test
.type lh_test, @function

lh_test:
test1:
    la t4, test_data_lh
    li t0, 0x12345678
    sw t0, 0(t4)
    lh t1, 0(t4)
    li t2, 0x5678
    beq t1, t2, test2
    j Fail_LH_1

test2:
    la t4, test_data_lh
    li t0, 0x0000FFFF
    sw t0, 0(t4)
    lh t1, 0(t4)
    li t2, -1
    beq t1, t2, test3
    j Fail_LH_2

test3:
    la t4, test_data_lh
    li t0, 0x12345678
    sw t0, 0(t4)
    lh t1, 2(t4)
    li t2, 0x1234
    beq t1, t2, pass
    j Fail_LH_3

pass:
    j return_lh_test

Fail_LH_1:
    li gp, 651
    j fail

Fail_LH_2:
    li gp, 652
    j fail

Fail_LH_3:
    li gp, 653
    j fail

.section .data
.align 4
test_data_lh:
    .word 0
