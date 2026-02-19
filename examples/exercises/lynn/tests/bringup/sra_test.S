// RV32I Test Suite
// sra_test.S
// Generated for E154 Lab 2

.extern return_sra_test
.extern fail

.section .text.init
.globl sra_test
.type sra_test, @function

sra_test:
test1:
li t0, 16
li t1, 4
sra t2, t0, t1
li t3, 1
beq t2, t3, test2
j Fail_SRA_1

test2:
li t0, 0x80000000
li t1, 1
sra t2, t0, t1
li t3, 0xC0000000
beq t2, t3, test3
j Fail_SRA_2

test3:
li t0, 0xFFFFFFFF
li t1, 8
sra t2, t0, t1
li t3, 0xFFFFFFFF
beq t2, t3, pass
j Fail_SRA_3

pass:
j return_sra_test

Fail_SRA_1:
li gp, 541
j fail

Fail_SRA_2:
li gp, 542
j fail

Fail_SRA_3:
li gp, 543
j fail
