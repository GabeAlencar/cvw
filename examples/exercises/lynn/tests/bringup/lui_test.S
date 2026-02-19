// RV32I Test Suite
// lui_test.S
// Generated for E154 Lab 2

.extern return_lui_test
.extern fail

.section .text.init
.globl lui_test
.type lui_test, @function

lui_test:
test1:
lui t0, 0x12345
li t1, 0x12345000
beq t0, t1, test2
j Fail_LUI_1

test2:
lui t0, 0xFFFFF
li t1, 0xFFFFF000
beq t0, t1, test3
j Fail_LUI_2

test3:
lui t0, 0
li t1, 0
beq t0, t1, pass
j Fail_LUI_3

pass:
j return_lui_test

Fail_LUI_1:
li gp, 701
j fail

Fail_LUI_2:
li gp, 702
j fail

Fail_LUI_3:
li gp, 703
j fail
