.data
n: .word 1032
k: .word 3
fraza1: .asciiz "apare"
fraza2: .asciiz "nu apare"
.text
main:
subu $sp, $sp, 8
lw $t0, n
sw $t0, 0($sp)
lw $t0, k
sw $t0, 4($sp)
jal verificare
addu $sp, $sp, 8
beq $v0, 1, apare
la $a0, fraza2
j exit
apare:
la $a0, fraza1
exit:
li $v0, 4
syscall
li $v0, 10
syscall

verificare:
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 0
	lw $t0, 4($fp)
	lw $t1, 8($fp)
	li $t2, 10
	loop:
		beq $t0, 0, iesire
		beq $v0, 1, iesire
		div $t0, $t2
		mflo $t0
		mfhi $t3
		bne $t1, $t3, next
		li $v0, 1
		next:
		j loop
	iesire:
	lw $fp, 0($fp) 
	addu $sp, $sp, 4
jr $ra