// RV32I Test Suite
// blt_test.S
// Generated for E154 Lab 2

.extern return_blt_test
.extern fail

.section .text.init
.globl blt_test
.type blt_test, @function

blt_test:
test1:
li t0, 5
li t1, 10
blt t0, t1, test2
j Fail_BLT_1
j Fail_BLT_1

test2:
li t0, 10
li t1, 5
li t2, 1
blt t0, t1, Fail_BLT_2
beq t2, t2, test3
j Fail_BLT_2

test3:
li t0, -5
li t1, 5
blt t0, t1, pass
j Fail_BLT_3
j Fail_BLT_3

pass:
j return_blt_test

Fail_BLT_1:
li gp, 591
j fail

Fail_BLT_2:
li gp, 592
j fail

Fail_BLT_3:
li gp, 593
j fail
