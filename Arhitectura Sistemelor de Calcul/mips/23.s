.data

string: .space 400
c: .ascii "a"
n: .word 7

.text

suprascriere:
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
	lb $s1, 4($fp)
	lw $s2, 8($fp)
	lw $s3, 12($fp)
	li $s4, 0
	loop:
		beq $s4, $s2, exit
		sb $s1, 0($s0)
		addi $s4, $s4, 1
		addi $s0, $s0, 1 
		j loop
	exit:
	sb $s3, 0($s0)
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 16
la $t0, string
sw $t0, 0($sp)
la $t0, c
lb $t0, 0($t0)
sb $t0, 4($sp)
lw $t0, n
sw $t0, 8($sp)
li $t0, 0
sw $t0, 12($sp)
jal suprascriere
addu $sp, 16
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall
