.data

string: .space 100

.text

intregi:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	lw $s0, 0($fp)
	loop:
		li $v0, 5
		syscall
		beq $v0, -1, exit
		addi $s1, $v0, 48
		sb $s1, 0($s0)
		addi $s0, $s0, 1
		j loop
	exit:
	li $s1, 0
	sb $s1, 0($s0)
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addu $sp, 8
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 4
la $t0, string
sw $t0, 0($sp)
jal intregi
addu $sp, 4
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall
