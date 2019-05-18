    .text
    .align  2
    .globl  main
    .ent    main

# write commands to the gpu_command port
gpu_comm:
    sll     $4, 24
    or      $4, $5
    sw      $4, 0x1f801814
    j       $31

# write commands to the gpu_data port
gpu_data:
    sll     $4, 24
    or      $4, $5
    sw      $4, 0x1f801810
    j       $31

# Init the gpu so we're ready to draw
init_gpu:
    # Save the return address
    move    $16, $31

    # Reset the GPU
    li      $4, 0
    li      $5, 0
    jal     gpu_comm
    # Set the horizontal start/end
    li      $4, 6
    li      $5, 0xc56
    sll     $5, 12
    or      $5, 0x250
    jal     gpu_comm
    # Set the vertical start/end
    li      $4, 7
    li      $5, 0x100
    sll     $5, 10
    or      $5, 0x10
    jal     gpu_comm
    # Set display mode
    li      $4, 8
    li      $5, 0x21 # 0b0010_0001
    jal     gpu_comm
    # Set display offset
    li      $4, 5
    li      $5, 0x0
    jal     gpu_comm
    # Set draw mode
    li      $4, 0xe1
    li      $5, 0x200
    jal     gpu_data
    # Set draw area
    li      $4, 0xe3
    li      $5, 0x0
    jal     gpu_data
    # Set draw area
    li      $4, 0xe4
    li      $5, 0x3BD
    sll     $5, 8
    or      $5, 0x3F
    jal     gpu_data
    # Set draw offset
    li      $4, 0xe5
    li      $5, 0x0
    jal     gpu_data
    # Set DMA to CPU->GPU
    li      $4, 4
    li      $5, 0x2
    jal     gpu_comm
    # Enable the display
    li      $4, 0x3
    li      $5, 0x0
    jal     gpu_comm

    # Restore the return address, and return
    move    $31, $16
    j       $31

main:
    # Save stack pointer, frame pointer, and return address
    subu    $sp,$sp,24
    sw      $31,20($sp)
    sw      $fp,16($sp)
    move    $fp,$sp

    jal     init_gpu

    # Infinite loop
    move    $6, $0
    li      $7, 0xfffff
_main_loop:
    # Clear screen
    li      $2, 0x2
    sll     $2, 24
    or      $2, 0x0 # Black
    sw      $2, 0x1f801810
    li      $2, 0x0
    sw      $2, 0x1f801810
    li      $2, 0x01ff03ff
    sw      $2, 0x1f801810

    li      $7, 0xfffff
    add     $6, 1

    li      $2, 0x03000000
    sw      $2, 0x1f801814
    li      $2, 0x30
    sll     $2, 24
    or      $2, $2, 0x00ff0000
    and     $6, 0xff
    or      $2, $6
    sw      $2, 0x1f801810

    li      $2, 0x00500000
    add     $2, $6
    sw      $2, 0x1f801810

    li      $2, 0x0000ff00
    add     $2, $6
    sw      $2, 0x1f801810

    li      $2, 0x00500050
    add     $2, $6
    sw      $2, 0x1f801810

    li      $2, 0x000000ff
    add     $2, $6
    sw      $2, 0x1f801810

    li      $2, 0x00C00050
    add     $2, $6
    sw      $2, 0x1f801810

    # Spin for a bit
_main_spin:
    sub     $7, 1
    bne     $7, $0, _main_spin

    j       _main_loop

    # Restore and return
    move    $sp,$fp
    lw      $31,20($sp)
    lw      $fp,16($sp)
    addu    $sp,$sp,24
    j       $31
