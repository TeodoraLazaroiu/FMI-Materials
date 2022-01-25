.data
v: .word 10, 20, 1, 2
v1: .space 20
n: .word 4
fraza: .asciiz "pliat"
.text

pliat:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 28
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	lw $t0, 0($fp)
	lw $t1, 4($fp)
	move $t2, $t1
	mul $t2, $t2, 4
	sub $t2, $t2, 4
	add $t2, $t2, $t0
	la $t5, v1
	loop_pliat:
		bgt $t0, $t2, exit_pliat
		lw $t3, 0($t0)
		lw $t4, 0($t2)
		add $t3, $t3, $t4
		sw $t3, 0($t5)
		addi $t0, $t0, 4
		sub $t2, $t2, 4
		addi $t5, $t5, 4
		j loop_pliat
	exit_pliat:
	addi $t1, $t1, 1
	li $t6, 2
	div $t1, $t6
	mflo $v0
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	addu $sp, 28
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 8
la $t0, v
sw $t0, 0($sp)
lw $t0, n
sw $t0, 4($sp)
jal pliat
move $t0, $v0
li $t1, 0
la $t2, v1
printare:
	beq $t1, $t0, exit_printare
	lw $a0, 0($t2)
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	addi $t2, $t2, 4
	addi $t1, $t1, 1
	j printare
exit_printare:
la $a0, fraza
li $v0, 4
syscall
li $v0, 10
syscall

