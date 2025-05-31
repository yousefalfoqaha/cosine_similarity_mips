.data
welcome_message:	.asciiz "Welcome to MIPS Assembly using MARS Simulator\nAn assembly program to compute cosine similarity between two variables\nWritten by: Yousef Mustafa; 20239502126\n"
ask_vector_size:        .asciiz "Enter a vector size m between 5 and 10: "
bad_vector_size:        .asciiz "\nVector must be between 5 and 10.\n"
ask_vector_a_elements:  .asciiz "Input vector a elements:\n"
ask_vector_b_elements:  .asciiz "Input vector b elements:\n"
result_message:         .asciiz "Cosine similarity result: "
newline:                .asciiz "\n"

.text
main:
	li	$v0, 4
	la	$a0, welcome_message
	syscall

	la	$a0, newline
	syscall

    	la      $a0, ask_vector_size
    	syscall

    	li      $v0, 5
    	syscall

    	li      $t5, 5
    	li      $t6, 10
    	blt     $v0, $t5, bad_vector_size_exception
    	bgt     $v0, $t6, bad_vector_size_exception

    	move    $s0, $v0

    	li      $v0, 4
	la      $a0, ask_vector_a_elements
	syscall

    	li      $a2, 0x10010000
    	jal     input_vector

    	li      $v0, 4
    	la      $a0, ask_vector_b_elements
    	syscall

    	li      $a2, 0x10010040
    	jal     input_vector

    	li      $a0, 0x10010000
    	li      $a1, 0x10010040
    	jal     cosine_similarity

    	li      $v0, 4
    	la      $a0, result_message
    	syscall

    	mov.s   $f12, $f30
    	li      $v0, 2
    	syscall

    	li      $v0, 4
    	la      $a0, newline
    	syscall

    	li      $v0, 10
    	syscall

# args: a2 = base address for vector
input_vector:
    	li      $t5, 0

input_loop:
    	li      $v0, 6
    	# BEFORE: li $v0, 5 (only reads integers)
    	syscall

    	s.s     $f0, 0($a2)

    	addi    $a2, $a2, 4
    	addi    $t5, $t5, 1

    	blt     $t5, $s0, input_loop
    	jr      $ra

# args: a2 = first vector address, a3 = second vector address
dot_product:
    	li      $t5, 0
    	mtc1    $zero, $f30
    	cvt.s.w $f30, $f30

dot_product_loop:
    	l.s     $f10, 0($a2)
    	l.s     $f20, 0($a3)
    	mul.s   $f10, $f10, $f20
    	add.s   $f30, $f30, $f10

    	addi    $t5, $t5, 1
    	addi    $a2, $a2, 4
    	addi    $a3, $a3, 4

    	blt     $t5, $s0, dot_product_loop
    	jr      $ra

# args: a2 = vector address
euclidean_norm:
    	addi    $sp, $sp, -4
    	sw      $ra, 0($sp)

   	move    $a3, $a2
    	jal     dot_product

    	sqrt.s  $f30, $f30

    	lw      $ra, 0($sp)
    	addi    $sp, $sp, 4
    	jr      $ra

cosine_similarity:
    	addi    $sp, $sp, -12
    	sw      $ra, 8($sp)

    	move    $a2, $a0
    	move    $a3, $a1
    	jal     dot_product
    	s.s     $f30, 4($sp)

    	move    $a2, $a0
    	jal     euclidean_norm
    	s.s     $f30, 0($sp)

    	move    $a2, $a1
    	jal     euclidean_norm

    	l.s     $f20, 0($sp)
    	mul.s   $f10, $f30, $f20

    	l.s     $f20, 4($sp)
    	div.s   $f30, $f20, $f10

    	lw      $ra, 8($sp)
    	addi    $sp, $sp, 12
    	jr      $ra

bad_vector_size_exception:
    	li      $v0, 4
    	la      $a0, bad_vector_size
    	syscall

    	li      $v0, 10
    	syscall
