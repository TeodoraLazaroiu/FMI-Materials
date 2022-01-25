.data

string: .asciiz ""

.text

inverseaza:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 8
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	lw $s0, 0($fp)
	move $s2, $sp
	loop1:
		lb $s1, 0($s0)
		beq $s1, 0, exit1
		subu $sp, 4
		sb $s1, 0($sp)
		addi $s0, $s0, 1
		j loop1
	exit1:
	lw $s0, 0($fp)
	loop2:
		beq $sp, $s2, exit2
		lb $s1, 0($sp)
		sb $s1, 0($s0)
		addi $s0, $s0, 1
		addu $sp, 4
		j loop2
	exit2:
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	addu $sp, 8
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 4
la $t0, string
sw $t0, 0($sp)
jal inverseaza
addu $sp, 4
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall
