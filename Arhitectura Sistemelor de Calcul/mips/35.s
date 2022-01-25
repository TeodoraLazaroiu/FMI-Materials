.data
v: .word -1, -2, -3, -4, -5, -6
n: .word 6
fraza1: .asciiz "Exista"
fraza2: .asciiz "Nu exista"
.text
main:
subu $sp, $sp, 8
la $t0, v
sw $t0, 0($sp)
lw $t0, n
sw $t0, 4($sp)
jal verifica
addu $sp, $sp, 8
beq $v0, 0, nuexista
la $a0, fraza1
j exit
nuexista:
la $a0, fraza2
exit:
li $v0, 4
syscall
li $v0, 10
syscall

verifica:
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 0
	li $t0, 0
	lw $t1, 8($fp)
	lw $t2, 4($fp)
	loop:
		beq $t0, $t1, iesire
		beq $v0, 1, iesire
		lw $t3, 0($t2)
		ble $t3, 0, next
		li $v0, 1
		next:
		addi $t0, $t0, 1
		addi $t2, $t2, 4
		j loop
	iesire:
	lw $fp, 0($fp)
	addu $sp, $sp, 4
jr $ra
