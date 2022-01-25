.data

v: .word 4, 10, 5, 19
l: .word 4
mesaj: .asciiz "ok"

.text

extinde:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	li $s2, 1
	lw $s3, 0($s0)
	addi $s0, $s0, 4
	loop:
		beq $s2, $s1, exit
		sw $s3, 0($s0)
		addi $s0, $s0, 4
		addi $s2, $s2, 1
		j loop
	exit:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addu $sp, 16
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 8
la $t0, v
sw $t0, 0($sp)
lw $t0, l
sw $t0, 4($sp)
jal extinde
addu $sp, 8
la $a0, mesaj
li $v0, 4
syscall
li $v0, 10
syscall
