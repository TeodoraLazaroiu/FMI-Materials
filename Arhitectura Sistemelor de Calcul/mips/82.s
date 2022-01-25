.data
s:.asciiz "3*5"
.text
main:
subu $sp,$sp,4
la $t0,s
sw $t0,0($sp)

jal procedura

addu $sp,$sp,4
move $a0,$t3
li $v0,1
syscall


li $v0,10
syscall

procedura:
subu $sp,4
sw $fp,0($sp)
addi $fp,$sp,4   # <fp> <s>

subu $sp,4
sw $s0,0($sp)    # <s0> <fp> <sp>

lw $s0,0($fp)

lb $t0,0($s0)
addi $s0,$s0,1

lb $t1,0($s0)
addi $s0,$s0,1

lb $t2,0($s0)
li $t4,42
li $t5,43
sub $t0,$t0,48
sub $t2,$t2,48
beq $t1,$t4,orii
beq $t1,$t5,plus
j exit
li $t3,0
orii:
mul $t3,$t0,$t2
j exit

plus:
add $t3,$t0,$t2
j exit

exit:
lw $s0,-8($fp)
lw $fp,-4($fp)
addu $sp,$sp,8
jr $ra

 

