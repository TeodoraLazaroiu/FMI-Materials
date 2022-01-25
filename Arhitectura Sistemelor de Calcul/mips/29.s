.data

v: .word 0, 0, 0, 0
l: .word 4
x: .word 0
y: .word 0
string1: .asciiz "la fel"
string2: .asciiz "nu la fel"

.text

minsuma:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $s2, 8($fp)
	lw $s3, 12($fp)
	li $s4, 1
	lw $s5, 0($s0)
	lw $s6, 0($s0)
	addi $s0, $s0, 4
	loop1:
		beq $s4, $s1, exit1
		lw $s7, 0($s0)
		add $s6, $s6, $s7
		bge $s7, $s5, numaimic
		move $s5, $s7
		numaimic:
		addi $s4, $s4, 1
		addi $s0, $s0, 4
		j loop1
	exit1:
	sw $s5, 0($s2)
	sw $s6, 0($s3)
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addu $sp, 32
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 16
la $t0, v
sw $t0, 0($sp)
lw $t0, l 
sw $t0, 4($sp)
la $t0, x
sw $t0, 8($sp)
la $t0, y
sw $t0, 12($sp)
jal minsuma
addu $sp, 16
lw $t0, x
lw $t1, y
bne $t1, $t0, nuegal
la $a0, string1
j exit
nuegal:
la $a0, string2
exit:
li $v0, 4
syscall
li $v0, 10
syscall

