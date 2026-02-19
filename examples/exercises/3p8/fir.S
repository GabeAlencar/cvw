# fir.S
# RISC-V Assembly implementation of FIR filter
# void fir(int x[], int c[], int y[], int n, int m)
# a0 = x[] base address
# a1 = c[] base address
# a2 = y[] base address
# a3 = n
# a4 = m

.section .text
.global fir

fir:
    # Calculate number of iterations for outer loop: count = n - m + 1
    sub     t0, a3, a4      # t0 = n - m
    addi    t0, t0, 1       # t0 = n - m + 1 (outer loop count)
    blez    t0, done        # If count <= 0, return

    # Pre-compute offset to end of coefficients for resetting pointer
    slli    t6, a4, 2       # t6 = m * 4 (byte offset for c array size)

outer_loop:
    li      t1, 0           # t1 = accumulator for y[j] (sum)
    mv      t2, a4          # t2 = inner loop counter (i = m)

    # Setup pointers for this inner loop iteration
    # c pointer starts at a1 (c[0])
    mv      t3, a1

    # x pointer needs to start at x[j + m - 1]
    # We maintain a0 pointing to x[j].
    # So we need a temporary x pointer at a0 + (m-1)*4
    addi    t5, a4, -1      # t5 = m - 1
    slli    t5, t5, 2       # t5 = (m - 1) * 4
    add     t4, a0, t5      # t4 = address of x[j + m - 1]

inner_loop:
    lw      t5, 0(t3)       # load c[i]
    lw      a5, 0(t4)       # load x[current]

    # mul_q31 logic: (long)a * (long)b >> 31
    mul     a5, t5, a5      # 64-bit multiply (result in a5 on RV64)
    srai    a5, a5, 31      # Arithmetic shift right by 31

    # add_q31 logic: sum += result
    add     t1, t1, a5      # Accumulate result

    addi    t3, t3, 4       # c_ptr++
    addi    t4, t4, -4      # x_ptr--
    addi    t2, t2, -1      # i--
    bnez    t2, inner_loop  # if i > 0, continue

    sw      t1, 0(a2)       # Store result y[j]

    addi    a0, a0, 4       # Increment x base pointer (effective x[j] -> x[j+1])
    addi    a2, a2, 4       # Increment y destination pointer
    addi    t0, t0, -1      # Decrement outer loop counter
    bnez    t0, outer_loop  # Continue outer loop

done:
    ret
