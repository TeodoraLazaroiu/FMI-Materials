.data

string: .space 100

.text

generator:
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
	li $s2, 0
	bge $s0, 0, pozitiv
	li $s2, 32767
	addi $s2, $s2, 1
	sll $s2, $s2, 15
	sub $s2, $s2, 1
	sll $s2, $s2, 1
	addi $s2, $s2, 1
	add $s0, $s0, $s2
	addi $s0, $s0, 1
	li $s2, 1
	pozitiv:
	li $s3, 268435456
	loop:
		beq $s3, 0, exit
		div $s4, $s0, $s3
		bne $s2, 1, nuneg
		addi $s4, $s4, 8
		li $s2, 0
		nuneg:
		addi $s4, $s4, 65
		sb $s4, 0($s1)
		rem $s0, $s0, $s3
		div $s3, $s3, 16
		addi $s1, $s1, 1
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
subu $sp, 8
li $t0, 2352283649
sw $t0, 0($sp)
la $t0, string
sw $t0, 4($sp)
jal generator
addu $sp, 8
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall
