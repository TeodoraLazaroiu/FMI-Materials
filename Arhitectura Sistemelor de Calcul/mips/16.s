.data

string: .asciiz "sternocleidomastoidian"

.text

caracter:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lb $s2, 8($fp)
	li $s3, 0
	loop:
		lb $s4, 0($s0)
		beq $s4, 0, exit
		blt $s3, $s1, nuswap
		sb $s2, 0($s0)
		j exit
		nuswap:
		addi $s3, $s3, 1
		addi $s0, $s0, 1
		j loop
	exit:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addu $sp, 20
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 12
la $t0, string
sw $t0, 0($sp)
li $v0, 5
syscall
sw $v0, 4($sp)
li $v0, 12
syscall
sb $v0, 8($sp)
la $a0, 10
li $v0, 11
syscall
jal caracter
addu $sp, 12
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall
