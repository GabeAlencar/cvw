// RV32I Test Suite
// sh_test.S
// Using data section

.extern return_sh_test
.extern fail

.section .text.init
.globl sh_test
.type sh_test, @function

sh_test:
test1:
    la t4, test_data_sh
    li t0, 0xFFFFFFFF
    sw t0, 0(t4)
    li t1, 0xABCD
    sh t1, 0(t4)
    lw t2, 0(t4)
    li t3, 0xFFFFABCD
    beq t2, t3, test2
    j Fail_SH_1

test2:
    la t4, test_data_sh
    li t0, 0x00000000
    sw t0, 0(t4)
    li t1, 0x12345678
    sh t1, 2(t4)
    lw t2, 0(t4)
    li t3, 0x56780000
    beq t2, t3, test3
    j Fail_SH_2

test3:
    la t4, test_data_sh
    li t0, 0xFFFF0000
    sw t0, 0(t4)
    li t1, 0x1234
    sh t1, 0(t4)
    lw t2, 0(t4)
    li t3, 0xFFFF1234
    beq t2, t3, pass
    j Fail_SH_3

pass:
    j return_sh_test

Fail_SH_1:
    li gp, 681
    j fail

Fail_SH_2:
    li gp, 682
    j fail

Fail_SH_3:
    li gp, 683
    j fail

.section .data
.align 4
test_data_sh:
    .word 0
