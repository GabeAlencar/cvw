// RV32I Test Suite
// srai_test.S
// Generated for E154 Lab 2

.extern return_srai_test
.extern fail

.section .text.init
.globl srai_test
.type srai_test, @function

srai_test:
test1:
li t0, 16
srai t1, t0, 4
li t2, 1
beq t1, t2, test2
j Fail_SRAI_1

test2:
li t0, 0x80000000
srai t1, t0, 1
li t2, 0xC0000000
beq t1, t2, test3
j Fail_SRAI_2

test3:
li t0, 0xFFFFFFF0
srai t1, t0, 4
li t2, 0xFFFFFFFF
beq t1, t2, pass
j Fail_SRAI_3

pass:
j return_srai_test

Fail_SRAI_1:
li gp, 551
j fail

Fail_SRAI_2:
li gp, 552
j fail

Fail_SRAI_3:
li gp, 553
j fail
