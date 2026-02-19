// RV32I Test Suite
// lb_test.S
// Using data section instead of stack

.extern return_lb_test
.extern fail

.section .text.init
.globl lb_test
.type lb_test, @function

lb_test:
test1:
    # Use a register as base address (relative to PC)
    la t4, test_data
    li t0, 0x12345678
    sw t0, 0(t4)
    lb t1, 0(t4)
    li t2, 0x78
    beq t1, t2, test2
    j Fail_LB_1

test2:
    la t4, test_data
    li t0, 0x000000FF
    sw t0, 0(t4)
    lb t1, 0(t4)
    li t2, -1
    beq t1, t2, test3
    j Fail_LB_2

test3:
    la t4, test_data
    li t0, 0x12345678
    sw t0, 0(t4)
    lb t1, 3(t4)
    li t2, 0x12
    beq t1, t2, pass
    j Fail_LB_3

pass:
    j return_lb_test

Fail_LB_1:
    li gp, 631
    j fail

Fail_LB_2:
    li gp, 632
    j fail

Fail_LB_3:
    li gp, 633
    j fail

.section .data
.align 4
test_data:
    .word 0
