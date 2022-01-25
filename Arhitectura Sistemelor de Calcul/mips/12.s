.data
s: .space 100
c1: .ascii "a"
c2: .ascii "z"
.text
main:
subu $sp, $sp, 12
la $t0, s
sw $t0, 0($sp)
la $t0, c1
lb $t1, 0($t0)
sb $t1, 4($sp)
la $t0, c2
lb $t1, 0($t0)
sb $t1, 8($sp)
jal string
addu $sp, $sp, 12
la $a0, s
li $v0, 4
syscall
li $v0, 10
syscall

string:
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	addiu $fp, $sp, 4
	subu $sp, $sp, 12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	lw $s0, 0($fp)
	lb $s1, 4($fp)
	lb $s2, 8($fp)
	loop:
		bgt $s1, $s2, iesire
		sb $s1, 0($s0)
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		j loop
	iesire:
	li $s1, 0
	sb $s1, 0($s0)
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addu $sp, $sp, 12
	lw $fp, 0($fp) 
	addu $sp, $sp, 4
jr $ra
