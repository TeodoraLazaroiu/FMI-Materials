.data
v:.space 400
k:.word 2
x:.word 3
m1:.asciiz "o cifra"
m2:.asciiz "mai mult de o cifra"
.text
main:
subu $s0,$sp,12
la $t0,v
sw $t0,0($sp)
lw $t0,k
sw $t0,4($sp)
lw $t0,x
sw $t0,8($sp)

jal procedura

addu $sp,$sp,12
la $t2,v
addi $t2,$t2,1
lb $t4,0($t2)
move $t3,$t4
beq $t3,45,ocifra
j maimult

ocifra:
la $a0,m1
j e
maimult:
la $a0,m2

e:
li $v0,4
syscall


li $v0,10
syscall

procedura:
subu $sp,4
sw $fp,0($sp)
addi $fp,$sp,4  # <fp>, <x> <k> <adresa v>

lw $s0,0($fp)
lw $s1,4($fp)
lw $s2,8($fp)
loop:
beq $s1,0,exit1
div $s1,$s2
mflo $t2
mfhi $t1
move $s1,$t2
addi $t1,$t1,48
sb $t1,0($s0)
addi $s0,$s0,1
j loop
exit1:
li $t1,45
sb $t1,0($s0)
addi $s0,$s0,1
li $t1,49
sb $t1,0($s0)
lw $fp, -4 ($fp)
addu $sp,4
jr $ra


