// RV32I Test Suite
// bltu_test.S
// Generated for E154 Lab 2

.extern return_bltu_test
.extern fail

.section .text.init
.globl bltu_test
.type bltu_test, @function

bltu_test:
test1:
li t0, 5
li t1, 10
bltu t0, t1, test2
j Fail_BLTU_1
j Fail_BLTU_1

test2:
li t0, 10
li t1, 5
li t2, 1
bltu t0, t1, Fail_BLTU_2
beq t2, t2, test3
j Fail_BLTU_2

test3:
li t0, 1
li t1, 0xFFFFFFFF
bltu t0, t1, pass
j Fail_BLTU_3
j Fail_BLTU_3

pass:
j return_bltu_test

Fail_BLTU_1:
li gp, 601
j fail

Fail_BLTU_2:
li gp, 602
j fail

Fail_BLTU_3:
li gp, 603
j fail
