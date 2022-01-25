.data
string: .asciiz "Ana are mere"
par: .asciiz "Rezultat par"
impar: .asciiz "Rezultat impar"
.text
main:
subu $sp, $sp, 4
la $t0, string
sw $t0, 0($sp)
jal calcul
addu $sp, $sp, 4
rem $v0, $v0, 2
beq $v0, 0, nrpar
la $a0, impar
j exit
nrpar:
la $a0, par
exit:
li $v0, 4
syscall
li $v0, 10
syscall 

calcul:
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 0
	lw $t0, 4($fp)
	li $v0, 0
	loop:
		lb $t1, 0($t0)
		beq $t1, 0, iesire
		add $v0, $v0, $t1
		addi $t0, $t0, 1
		j loop
	iesire:
	lw $fp, 0($fp)
	addu $sp, $sp, 4
jr $ra
