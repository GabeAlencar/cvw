// RV32I Test Suite
// auipc_test.S
// Generated for E154 Lab 2

.extern return_auipc_test
.extern fail

.section .text.init
.globl auipc_test
.type auipc_test, @function

auipc_test:
test1:
    auipc t0, 0
    la t1, test1
    beq t0, t1, test2
    j Fail_AUIPC_1

test2:
    auipc t0, 1
    la t1, test2
    lui t2, 1
    add t1, t1, t2
    beq t0, t1, test3
    j Fail_AUIPC_2

test3:
    auipc t0, 0xFFFFF
    la t1, test3
    lui t2, 0xFFFFF
    add t1, t1, t2
    beq t0, t1, pass
    j Fail_AUIPC_3

pass:
    j return_auipc_test

Fail_AUIPC_1:
    li gp, 711
    j fail

Fail_AUIPC_2:
    li gp, 712
    j fail

Fail_AUIPC_3:
    li gp, 713
    j fail
