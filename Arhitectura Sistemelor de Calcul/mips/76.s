.data

v: .byte 75, 181, 108, 211, 232, 154, 235, 0, 3, 192
l: .word 10

.text

biti:
	subu $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, 4
	sw $s0, 0($sp)
	lb $s0, 0($fp)
	and $v0, $s0, 170
	and $s0, $s0, 85
	srl $v0, $v0, 1
	sll $s0, $s0, 1
	or $v0, $v0, $s0
	lw $s0, 0($sp) 
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
la $t0, v
lw $t1, l
li $t2, 0
loop:
	beq $t2, $t1, exit
	lb $t3, 0($t0)
	subu $sp, 4
	sb $t3, 0($sp)
	jal biti
	addu $sp, 4
	bne $t3, $v0, nuegale
	li $a0, 101
	j next
	nuegale:
	li $a0, 100
	next:
	li $v0, 11
	syscall 
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j loop
exit:
li $v0, 10
syscall
