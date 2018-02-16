.globl 	setpixel
.data
a0: .word   1 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
a1: .word   1#COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
a2: .word   0 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
a3: .word   0 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
sp: .word   255 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO

# ordem argumentos: linha,coluna,red,green,blue
#$a0 linha
#$a1 coluna
#$a2 red
#$a3 green
#0($sp) blue 

.text	
setpixel:	
	##TESTE
		la	$a0, a0	 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
		la	$a1, a1	 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
		la	$a2, a2	 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
		la	$a3, a3	 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO
		la	$sp, sp	 #COMENTAR LINHA SE FOR PARA USAR UM ENDERE�O PASSADO A FUNCAO MESMO

	##FIM DE COISAS DO TESTE
		
	
	#calculo da cor	 guardar no registo t1, posso usar o registo 
	#vermelho(bits 16-23), verde (bits 8-15) e azul (bits 0-7)
	
	#vermelho
	lw	$t0 ,0($a2)	# meto o valor de RED em $t0
	sll 	$t1, $t0, 16 	#adiciona a componente vermelha
	
	#verde	
	lw	$t0 ,0($a3)	# meto o valor de GREEN em $t0
	sll	$t0, $t0, 8	#calcula a cor verde
	or	$t1, $t1, $t0	#adiciona a componente verde
	
	#Azul
	lbu	$t0 ,0($sp)	# meto o valor de BLUE em $t0
	or	$t1, $t1, $t0	#adiciona a componente azul, como o azul � nos primeiros 8 bits n�o � necessario fazer sll
	
	#inicializacao das variaveis importantes
	la	$t0, 0x10010000 #endere�o do display
	lw	$t2 ,0($a0)	# Numero de linhas a andar
	

	# ir para a linha	
	addi 	$t3, $0,0 	# garantir que o registo est� a zero
	addi 	$t3, $t3,256 	#t3=256
	mult 	$t3, $t2 	#t3 = t3* a0 (numero de bytes a avan�ar para ir para a linha pretendida
	mflo 	$t3
	
	add 	$t4, $t0, $t3 	# move o endere�o original para o endere�o pretendido t4= endere�o original+256*nlinhas
	
	# ir para coluna
	lw	$t2, 0($a1)	# Numero de colunas  a andar
	
	addi 	$t3, $0,0 	# limpar o registo t3
	addi 	$t3, $t3,4 	#t3=4
	mult 	$t3, $t2 	#t3 = t3* a1 (numero de bytes a avan�ar para ir para a coluna pretendida 
	mflo 	$t3
	
	add 	$t4, $t4, $t3 	#incrementa o numero de bytes necessario para ir para coluna desejada	

	
	# pinta o pixel com a cor pretendida
	sw 	$t1, 0($t4)	# coloca a cor pretendida no pixel pretendido
	jr 	$ra
