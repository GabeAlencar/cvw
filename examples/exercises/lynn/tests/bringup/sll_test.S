// Gabe Alencar
// gmenendezdealencar@g.hmc.edu
// 2/11/2026

.extern return_sll_test
.extern fail

.section .text.init
.globl sll_test
.type sll_test, @function

sll_test:
test1:
    # Test 1: Basic shift by 1
    li t0, 1
    li t1, 1
    sll t2, t0, t1
    li t3, 2
beq t2, t3, test2
j Fail_SLL_1

test2:
    # Test 2: Shift by 0 (no change)
    li t0, 0x12345678
    li t1, 0
    sll t2, t0, t1
    li t3, 0x12345678
beq t2, t3, test3
j Fail_SLL_2

test3:
    # Test 3: Shift by 31 (maximum)
    li t0, 1
    li t1, 31
    sll t2, t0, t1
    li t3, 0x80000000
beq t2, t3, test4
j Fail_SLL_3

test4:
    # Test 4: Shift causing overflow
    li t0, 0x80000000
    li t1, 1
    sll t2, t0, t1
    li t3, 0
beq t2, t3, test5
j Fail_SLL_4

test5:
    # Test 5: Only use lower 5 bits of shift amount
    li t0, 1
    li t1, 32  # Should use 0 (32 & 0x1F = 0)
    sll t2, t0, t1
    li t3, 1
beq t2, t3, test6
j Fail_SLL_5

test6:
    # Test 6: Shift all 1s pattern
    li t0, 0xFFFFFFFF
    li t1, 4
    sll t2, t0, t1
    li t3, 0xFFFFFFF0
beq t2, t3, test7
j Fail_SLL_6

test7:
    # Test 7: Shift pattern losing high bits
    li t0, 0xF0000000
    li t1, 4
    sll t2, t0, t1
    li t3, 0
beq t2, t3, test8
j Fail_SLL_7

test8:
    # Test 8: Shift small value by large amount
    li t0, 0x00000001
    li t1, 16
    sll t2, t0, t1
    li t3, 0x00010000
beq t2, t3, test9
j Fail_SLL_8

test9:
    # Test 9: Shift alternating pattern
    li t0, 0x55555555
    li t1, 1
    sll t2, t0, t1
    li t3, 0xAAAAAAAA
beq t2, t3, test10
j Fail_SLL_9

test10:
    # Test 10: Verify only lower 5 bits used (33 = 1)
    li t0, 0x00000002
    li t1, 33
    sll t2, t0, t1
    li t3, 0x00000004
beq t2, t3, pass
j Fail_SLL_10

pass:
j return_sll_test

Fail_SLL_1:
li gp, 501
j fail

Fail_SLL_2:
li gp, 502
j fail

Fail_SLL_3:
li gp, 503
j fail

Fail_SLL_4:
li gp, 504
j fail

Fail_SLL_5:
li gp, 505
j fail

Fail_SLL_6:
li gp, 506
j fail

Fail_SLL_7:
li gp, 507
j fail

Fail_SLL_8:
li gp, 508
j fail

Fail_SLL_9:
li gp, 509
j fail

Fail_SLL_10:
li gp, 510
j fail
