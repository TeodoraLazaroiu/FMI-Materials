.data

x: .word 0
y: .word 0
string1: .asciiz "la fel"
string2: .asciiz "nu la fel"

.text

la_fel:
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
	lw $s1, 4($fp)
	lw $s2, 8($fp)
	lw $s3, 12($fp)
	div $s4, $s0, $s1
	sw $s4, 0($s2)
	rem $s4, $s0, $s1
	sw $s4, 0($s3)
	rem $s5, $s0, $s1
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addu $sp, 20
	lw $fp, 0($sp)
	addu $sp, 4
jr $ra

main:
subu $sp, 16
li $t0, 3
sw $t0, 0($sp)
li $t0, 3
sw $t0, 4($sp)
la $t0, x
sw $t0, 8($sp)
la $t0, y
sw $t0, 12($sp)
jal la_fel
addu $sp, 16
lw $t0, x
lw $t1, y
sub $t0, $t0, $t1
and $t1, $t1, 1
beq $t1, 1, aceeasi
la $a0, string2
j exit
aceeasi:
la $a0, string1 
exit:
li $v0, 4
syscall
li $v0, 10
syscall
