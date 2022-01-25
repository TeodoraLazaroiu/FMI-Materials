.data
string: .asciiz "99987"
.text
main:
subu $sp, $sp, 4
la $t0, string
sw $t0, 0($sp)
jal succesor
addu $sp, $sp, 4
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall

succesor:
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 0
	lw $t0, 4($fp)
	li $t1, 0
	loop:
		lb $t2, 0($t0)
		beq $t2, 0, iesire
		beq $t1, 1, iesire
		bne $t2, 57, nu9
		li $t2, 48
		j next
		nu9:
		addi $t2, $t2, 1
		li $t1, 1
		next:
		sb $t2, 0($t0)
		addi $t0, $t0, 1
		j loop
	iesire: 
	lw $fp, 0($fp)
	addu $sp, $sp, 4
jr $ra
