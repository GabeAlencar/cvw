// RV32I Test Suite
// bne_test.S
// Generated for E154 Lab 2

.extern return_bne_test
.extern fail

.section .text.init
.globl bne_test
.type bne_test, @function

bne_test:
test1:
li t0, 5
li t1, 10
bne t0, t1, test2
j Fail_BNE_1
j Fail_BNE_1

test2:
li t0, 42
li t1, 42
li t2, 1
bne t0, t1, Fail_BNE_2
beq t2, t2, pass
j Fail_BNE_2

pass:
j return_bne_test

Fail_BNE_1:
li gp, 581
j fail

Fail_BNE_2:
li gp, 582
j fail
