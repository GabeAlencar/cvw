// RV32I Test Suite
// bge_test.S
// Generated for E154 Lab 2

.extern return_bge_test
.extern fail

.section .text.init
.globl bge_test
.type bge_test, @function

bge_test:
test1:
li t0, 10
li t1, 5
bge t0, t1, test2
j Fail_BGE_1
j Fail_BGE_1

test2:
li t0, 42
li t1, 42
bge t0, t1, test3
j Fail_BGE_2
j Fail_BGE_2

test3:
li t0, 5
li t1, -5
bge t0, t1, pass
j Fail_BGE_3
j Fail_BGE_3

pass:
j return_bge_test

Fail_BGE_1:
li gp, 611
j fail

Fail_BGE_2:
li gp, 612
j fail

Fail_BGE_3:
li gp, 613
j fail
