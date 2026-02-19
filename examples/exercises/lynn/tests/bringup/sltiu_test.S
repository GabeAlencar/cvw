// RV32I Test Suite
// sltiu_test.S
// Generated for E154 Lab 2

.extern return_sltiu_test
.extern fail

.section .text.init
.globl sltiu_test
.type sltiu_test, @function

sltiu_test:
test1:
li t0, 5
sltiu t1, t0, 10
li t2, 1
beq t1, t2, test2
j Fail_SLTIU_1

test2:
li t0, 10
sltiu t1, t0, 5
li t2, 0
beq t1, t2, test3
j Fail_SLTIU_2

test3:
li t0, 0xFFFFFFFF
sltiu t1, t0, 1
li t2, 0
beq t1, t2, pass
j Fail_SLTIU_3

pass:
j return_sltiu_test

Fail_SLTIU_1:
li gp, 571
j fail

Fail_SLTIU_2:
li gp, 572
j fail

Fail_SLTIU_3:
li gp, 573
j fail
