#
# plot( int * valores, unsigned red, unsigned green, unsigned blue)
#	a0		a1-> a2        a2->a3         a3->0(sp)
.globl plot
.data 
.text

plot:
	sub $sp, $sp, 20
	sw $s2, 16($sp)
	sw $s1, 12($sp) 
	sw $s0, 8($sp)
	sw $ra, 4($sp) 
	sw $a3, 0($sp) #B
	
	add $s0, $a0, $zero # linha que vai ter de pintar 
	add $s1, $zero, $zero #contador
	add $a2, $a1, $zero # R
	add $a3, $a2, $zero # G 
	addi $s2,$zero, 64

loop:
	lw $a0, 0($s0) # linha
	addi $a0, $a0, 32 # é relativo ao eixo
	add $a1, $s1, $zero # coluna que vai pintar, que é o contador.
	jal setpixel
	addi $s1, $s1, 1 # adiciona counter e coluna
	addi $s0, $s0, 4 #proximo ponto
	beq $s2, $s1, exit # fim
	j loop
exit:
	lw $a3, 0($sp)
	lw $ra, 4($sp)
	lw $s0, 8($sp) 
	lw $s1, 12($sp)
	lw $s2, 16($sp)
	add $sp, $sp, 20
	
	jr $ra
	
	 
