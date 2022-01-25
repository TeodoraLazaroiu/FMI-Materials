.data
nr1:.word 220
nr2:.word 284
.text
main:

subu $sp,8
lw $t0,nr1
sw $t0,0($sp)

lw $t0,nr2
sw $t0,4($sp)

jal procedura
addu $sp,$sp,8

move $a0,$v0
li $v0,1
syscall

li $v0,10
syscall

procedura:
subu $sp,4
sw $fp,0($sp)
addi $fp,$sp,4

lw $s0,0($fp)
lw $s1,4($fp)

li $t0,0 #suma
li $t1,1 #divizor
li $t2,0
li $t3,1
loop1:
beq $s0,$t1,exit1
move $s2,$s0
div $s2,$t1
mfhi $t4
beq $t4,0,suma1
addi $t1,$t1,1
j loop1
suma1:
add $t0,$t0,$t1
addi $t1,$t1,1
j loop1
exit1:
loop2:
beq $s1,$t3,exit2
move $s2,$s1
div $s2,$t3
mfhi $t4
beq $t4,0,suma2
addi $t3,$t3,1
j loop2
suma2:
add $t2,$t2,$t3
addi $t3,$t3,1
j loop2

exit2:

beq $t0,$s1,prietene
nuprietene:
li $v0,0
j exit3
prietene:
beq $t2,$s0,prietene2
j exit3
prietene2:
li $v0,1

exit3:
jr $ra