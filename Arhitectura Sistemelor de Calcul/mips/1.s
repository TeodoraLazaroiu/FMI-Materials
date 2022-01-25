.data

string: .asciiz "cabana"
l: .word 6

.text
inverseaza:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	lw $t0, 0($fp)
	lw $t1, 4($fp)
	sub $t1, $t1, 1
	add $t1, $t1, $t0
	loop:
		bge $t0, $t1, exit
		lb $t2, 0($t0)
		lb $t3, 0($t1)
		sb $t3, 0($t0)
		sb $t2, 0($t1)
		addi $t0, $t0, 1
		sub $t1, $t1, 1
		j loop
	exit:
	lw $fp, 0($sp)
	addu $sp, 4 
jr $ra

main:
subu $sp, 8 
la $t0, string
sw $t0, 0($sp)
lw $t0, l
sw $t0, 4($sp)
jal inverseaza
la $a0, string
li $v0, 4
syscall
li $v0, 10
syscall
