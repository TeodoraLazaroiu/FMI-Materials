.data
string: .asciiz "Ana are mer"
s: .space 100
.text
main:
subu $sp, 4
la $t0, string
sw $t0, 0($sp)
jal caractere
addu $sp, 4
la $a0, s
sb $v0, 0($a0)
sb $v1, 1($a0)
li $t0, 0
sb $t0, 2($a0)
li $v0, 4
syscall
li $v0, 10
syscall

caractere:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 16
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	li $s1, 0
	lw $s0, 0($fp)
	loop:
		lb $s2, 0($s0)
		beq $s2, 0, iesire
		addi $s1, $s1, 1
		addi $s0, $s0, 1
		j loop
	iesire:
	move $v1, $s2
	li $s2, 2
	div $s1, $s2
	mfhi $s3
	mflo $s2
	sub $s0, $s0, $s2	
	beq $s3, 1, impar
	lb $v0, -1($s0)
	lb $v1, 0($s0)
	j exit
	impar:
	lb $v0, -1($s0)
	exit:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addu $sp, 16
	lw $fp, 0($fp)
	addu $sp, 4
jr $ra
