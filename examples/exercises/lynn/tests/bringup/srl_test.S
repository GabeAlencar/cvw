// Gabe Alencar
// gmenendezdealencar@g.hmc.edu
// 2/11/2026

.extern return_srl_test
.extern fail

.section .text.init
.globl srl_test
.type srl_test, @function

srl_test:
test1:
    # Test 1: Basic shift by 1
    li t0, 2
    li t1, 1
    srl t2, t0, t1
    li t3, 1
beq t2, t3, test2
j Fail_SRL_1

test2:
    # Test 2: Shift by 0
    li t0, 0x12345678
    li t1, 0
    srl t2, t0, t1
    li t3, 0x12345678
beq t2, t3, test3
j Fail_SRL_2

test3:
    # Test 3: Shift MSB (unsigned)
    li t0, 0x80000000
    li t1, 1
    srl t2, t0, t1
    li t3, 0x40000000
beq t2, t3, test4
j Fail_SRL_3

test4:
    # Test 4: Shift all bits out
    li t0, 0x00000001
    li t1, 1
    srl t2, t0, t1
    li t3, 0
beq t2, t3, test5
j Fail_SRL_4

test5:
    # Test 5: Shift by 31
    li t0, 0x80000000
    li t1, 31
    srl t2, t0, t1
    li t3, 1
beq t2, t3, test6
j Fail_SRL_5

test6:
    # Test 6: Shift all 1s (zero extension)
    li t0, 0xFFFFFFFF
    li t1, 8
    srl t2, t0, t1
    li t3, 0x00FFFFFF
beq t2, t3, test7
j Fail_SRL_6

test7:
    # Test 7: Shift by 16
    li t0, 0xABCD0000
    li t1, 16
    srl t2, t0, t1
    li t3, 0x0000ABCD
beq t2, t3, test8
j Fail_SRL_7

test8:
    # Test 8: Only lower 5 bits of shift
    li t0, 0x80000000
    li t1, 32  # Treated as 0
    srl t2, t0, t1
    li t3, 0x80000000
beq t2, t3, test9
j Fail_SRL_8

test9:
    # Test 9: Shift alternating pattern
    li t0, 0xAAAAAAAA
    li t1, 1
    srl t2, t0, t1
    li t3, 0x55555555
beq t2, t3, test10
j Fail_SRL_9

test10:
    # Test 10: Shift by 24
    li t0, 0xFF000000
    li t1, 24
    srl t2, t0, t1
    li t3, 0x000000FF
beq t2, t3, pass
j Fail_SRL_10

pass:
j return_srl_test

Fail_SRL_1:
li gp, 521
j fail

Fail_SRL_2:
li gp, 522
j fail

Fail_SRL_3:
li gp, 523
j fail

Fail_SRL_4:
li gp, 524
j fail

Fail_SRL_5:
li gp, 525
j fail

Fail_SRL_6:
li gp, 526
j fail

Fail_SRL_7:
li gp, 527
j fail

Fail_SRL_8:
li gp, 528
j fail

Fail_SRL_9:
li gp, 529
j fail

Fail_SRL_10:
li gp, 530
j fail
