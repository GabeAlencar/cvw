// RV32I Test Suite
// bgeu_test.S
// Generated for E154 Lab 2

.extern return_bgeu_test
.extern fail

.section .text.init
.globl bgeu_test
.type bgeu_test, @function

bgeu_test:
test1:
li t0, 10
li t1, 5
bgeu t0, t1, test2
j Fail_BGEU_1
j Fail_BGEU_1

test2:
li t0, 42
li t1, 42
bgeu t0, t1, test3
j Fail_BGEU_2
j Fail_BGEU_2

test3:
li t0, 0xFFFFFFFF
li t1, 1
bgeu t0, t1, pass
j Fail_BGEU_3
j Fail_BGEU_3

pass:
j return_bgeu_test

Fail_BGEU_1:
li gp, 621
j fail

Fail_BGEU_2:
li gp, 622
j fail

Fail_BGEU_3:
li gp, 623
j fail
