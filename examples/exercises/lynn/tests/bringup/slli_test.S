// RV32I Test Suite
// slli_test.S
// Generated for E154 Lab 2

.extern return_slli_test
.extern fail

.section .text.init
.globl slli_test
.type slli_test, @function

slli_test:
test1:
li t0, 1
slli t1, t0, 4
li t2, 16
beq t1, t2, test2
j Fail_SLLI_1

test2:
li t0, 0x80000000
slli t1, t0, 1
li t2, 0
beq t1, t2, test3
j Fail_SLLI_2

test3:
li t0, 0xFFFFFFFF
slli t1, t0, 8
li t2, 0xFFFFFF00
beq t1, t2, pass
j Fail_SLLI_3

pass:
j return_slli_test

Fail_SLLI_1:
li gp, 511
j fail

Fail_SLLI_2:
li gp, 512
j fail

Fail_SLLI_3:
li gp, 513
j fail
