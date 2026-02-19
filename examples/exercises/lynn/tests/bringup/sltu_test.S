// RV32I Test Suite
// sltu_test.S
// Generated for E154 Lab 2

.extern return_sltu_test
.extern fail

.section .text.init
.globl sltu_test
.type sltu_test, @function

sltu_test:
test1:
li t0, 5
li t1, 10
sltu t2, t0, t1
li t3, 1
beq t2, t3, test2
j Fail_SLTU_1

test2:
li t0, 10
li t1, 5
sltu t2, t0, t1
li t3, 0
beq t2, t3, test3
j Fail_SLTU_2

test3:
li t0, 0xFFFFFFFF
li t1, 1
sltu t2, t0, t1
li t3, 0
beq t2, t3, pass
j Fail_SLTU_3

pass:
j return_sltu_test

Fail_SLTU_1:
li gp, 561
j fail

Fail_SLTU_2:
li gp, 562
j fail

Fail_SLTU_3:
li gp, 563
j fail
