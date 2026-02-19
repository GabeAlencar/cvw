// Gabe Alencar
// gmenendezdealencar@g.hmc.edu
// 2/11/2026

.extern return_srli_test
.extern fail

.section .text.init
.globl srli_test
.type srli_test, @function

srli_test:
test1:
    # Test 1: Basic shift by 1
    li t0, 2
    srli t2, t0, 1
    li t3, 1
beq t2, t3, test2
j Fail_SRLI_1

test2:
    # Test 2: Shift by 0
    li t0, 0x87654321
    srli t2, t0, 0
    li t3, 0x87654321
beq t2, t3, test3
j Fail_SRLI_2

test3:
    # Test 3: Shift MSB (zero extension)
    li t0, 0x80000000
    srli t2, t0, 1
    li t3, 0x40000000
beq t2, t3, test4
j Fail_SRLI_3

test4:
    # Test 4: Shift by 31
    li t0, 0x80000000
    srli t2, t0, 31
    li t3, 1
beq t2, t3, test5
j Fail_SRLI_4

test5:
    # Test 5: Shift negative (zero extend)
    li t0, 0xFFFFFFFF
    srli t2, t0, 8
    li t3, 0x00FFFFFF
beq t2, t3, test6
j Fail_SRLI_5

test6:
    # Test 6: Shift by 16
    li t0, 0xFFFF0000
    srli t2, t0, 16
    li t3, 0x0000FFFF
beq t2, t3, test7
j Fail_SRLI_6

test7:
    # Test 7: Shift by 4
    li t0, 0x12345678
    srli t2, t0, 4
    li t3, 0x01234567
beq t2, t3, test8
j Fail_SRLI_7

test8:
    # Test 8: Shift small value
    li t0, 0x00000010
    srli t2, t0, 4
    li t3, 0x00000001
beq t2, t3, test9
j Fail_SRLI_8

test9:
    # Test 9: Shift by 12
    li t0, 0xABC00000
    srli t2, t0, 12
    li t3, 0x000ABC00
beq t2, t3, test10
j Fail_SRLI_9

test10:
    # Test 10: Shift alternating bits
    li t0, 0x55555555
    srli t2, t0, 1
    li t3, 0x2AAAAAAA
beq t2, t3, pass
j Fail_SRLI_10

pass:
j return_srli_test

Fail_SRLI_1:
li gp, 531
j fail

Fail_SRLI_2:
li gp, 532
j fail

Fail_SRLI_3:
li gp, 533
j fail

Fail_SRLI_4:
li gp, 534
j fail

Fail_SRLI_5:
li gp, 535
j fail

Fail_SRLI_6:
li gp, 536
j fail

Fail_SRLI_7:
li gp, 537
j fail

Fail_SRLI_8:
li gp, 538
j fail

Fail_SRLI_9:
li gp, 539
j fail

Fail_SRLI_10:
li gp, 540
j fail
