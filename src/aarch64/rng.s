.data
.align 4
.globl seed
seed:
    .word 123456789

.text
.globl get_random_u32
.type get_random_u32, %function
get_random_u32:

    ldr x0, seed@GOT

    
=    ldr w1, [x0]

    ldr w2, =1664525
    mul w1, w1, w2          // w1 = X_n * a

    ldr w2, =1013904223
    add w1, w1, w2          // w1 = X_n * a + c =

=    str w1, [x0]
    
=    mov w0, w1
    ret

.globl set_seed_u32
.type set_seed_u32, %function
set_seed_u32:

    ldr x1, seed@GOT



    str w0, [x1]
    
    ret


.globl get_range_s32
.type get_range_s32, %function
get_range_s32:
    stp x29, x30, [sp, #-32]!
    mov x29, sp 
    stp x19, x20, [sp, #16] 

    mov w19, w0
    mov w20, w1
    
    bl get_random_u32
    
    sxtw x21, w20           // x21 = max (s64)
    sxtw x22, w19           // x22 = min (s64)
    sub x23, x21, x22       // x23 = max - min (s64)
    add x23, x23, #1        // x23 = signed range (s64)

    cmp x23, #0
    ble range_error_s32     // If range is <= 0, jump to error

    mov x0, x0              // w0->x0 (uint64)
    
    udiv x24, x0, x23       // x24 = raw_rng / range (unsigned division)
    msub x0, x24, x23, x0   // x0 = raw_rng % range (unsigned result in x0)

    mov w0, w0 
    
    add w0, w0, w19         // w0 = remainder + min (s32 result)
    
    b cleanup_return_s32

range_error_s32:
    mov w0, w19             // Return min on error

cleanup_return_s32:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret
