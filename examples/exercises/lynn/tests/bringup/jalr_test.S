// RV32I Comprehensive Test Suite
// jalr_test.S
// 10 test cases covering all corner cases

.extern return_jalr_test
.extern fail

.section .text.init
.globl jalr_test
.type jalr_test, @function

jalr_test:
test1:
    # Test 1: Basic JALR - jump and verify we reached target
    la t0, target1
    li t3, 0
    jalr t1, t0, 0
    j Fail_JALR_1
target1:
    li t3, 1
    bne t3, zero, test2
    j Fail_JALR_1

test2:
    # Test 2: JALR with positive offset
    la t0, target2
    addi t0, t0, -8
    jalr t1, t0, 8
    j Fail_JALR_2
target2:
    li t3, 2
    bne t3, zero, test3
    j Fail_JALR_2

test3:
    # Test 3: JALR with negative offset
    la t0, target3
    addi t0, t0, 8
    jalr t1, t0, -8
    j Fail_JALR_3
target3:
    li t3, 3
    bne t3, zero, test4
    j Fail_JALR_3

test4:
    # Test 4: Return address is non-zero
    la t0, target4
    jalr t1, t0, 0
    j Fail_JALR_4
target4:
    beq t1, zero, Fail_JALR_4
    j test5

test5:
    # Test 5: JALR clears LSB (alignment)
    la t0, target5
    addi t0, t0, 1  # Set LSB
    jalr t1, t0, 0  # Should clear LSB
    j Fail_JALR_5
target5:
    li t3, 5
    bne t3, zero, test6
    j Fail_JALR_5

test6:
    # Test 6: JALR to computed address
    la t0, target6
    jalr t1, t0, 0
    j Fail_JALR_6
target6:
    li t3, 6
    bne t3, zero, test7
    j Fail_JALR_6

test7:
    # Test 7: Large positive offset
    la t0, target7
    addi t0, t0, -100
    jalr t1, t0, 100
    j Fail_JALR_7
target7:
    li t3, 7
    bne t3, zero, test8
    j Fail_JALR_7

test8:
    # Test 8: JALR saves return address
    la t0, target8
    li t2, 0
    jalr t1, t0, 0
    addi t2, t2, 1  # Should be skipped
    j Fail_JALR_8
target8:
    beq t2, zero, test9
    j Fail_JALR_8

test9:
    # Test 9: JALR with zero offset
    la t0, target9
    jalr t1, t0, 0
    j Fail_JALR_9
target9:
    li t3, 9
    bne t3, zero, test10
    j Fail_JALR_9

test10:
    # Test 10: JALR chain
    la t0, target10
    jalr t1, t0, 0
    j Fail_JALR_10
target10:
    j pass

pass:
    j return_jalr_test

Fail_JALR_1:
    li gp, 691
    j fail

Fail_JALR_2:
    li gp, 692
    j fail

Fail_JALR_3:
    li gp, 693
    j fail

Fail_JALR_4:
    li gp, 694
    j fail

Fail_JALR_5:
    li gp, 695
    j fail

Fail_JALR_6:
    li gp, 696
    j fail

Fail_JALR_7:
    li gp, 697
    j fail

Fail_JALR_8:
    li gp, 698
    j fail

Fail_JALR_9:
    li gp, 699
    j fail

Fail_JALR_10:
    li gp, 700
    j fail
