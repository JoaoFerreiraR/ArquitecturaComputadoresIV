.globl 	drawaxis
.data
.text
drawaxis:
	#VAI GUARDAR VALORES IMPORTANTES NA STACK, PARA NAO SE PERDEREM
	addi	$sp, $sp, -16
	sw 	$s1, 12($sp) #guarda o valor de s1 no stack pointer
	sw	$s0, 8($sp)  # '' s0 ''
	sw	$ra, 4($sp) #IMPORTANTE: como vamos fazer um jal, ra vai ser alterado, isto guarda-o para o irmos buscar de novo mais tarde
	
	addi	$s1, $0, 64 	 #s1 = maximo de colunas, 64
	add	$s0, $0, $0 	 #contador = 0
	
loop:	beq 	$s0, $s1, sair 	 #se o contador chegar a 64, sai
	add	$a1, $0, $s0	 #coluna = contador, vai aumentar
	
	addi	$a0, $0, 32 	 #Linha= 32, meio de 64, visto o lado do ecra ser 64
	
	addi	$a2, $a2, 0 	 #Vermelho= 0
	addi	$a3, $a3, 0	 #Verde = 0
	sw	$0, 0($sp) 	 #guarda em sp o 5º argumento para setpixel funcionar. AKA azul=0, 0,0,0=preto
	jal 	setpixel	#set pixel com cor RGB preta
	addi	$s0, $s0, 1	#aumenta contador +1
	j 	loop
	
sair:	#volta a deixar a pilha como estava originalmente.
	lw	$ra, 4($sp)
	lw	$s0, 8($sp)
	lw	$s1, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra
