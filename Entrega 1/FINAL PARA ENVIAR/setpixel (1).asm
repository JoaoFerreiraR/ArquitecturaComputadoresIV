.globl 	setpixel
.data
# ordem argumentos: linha,coluna,red,green,blue
#$a0 linha
#$a1 coluna
#$a2 red
#$a3 green
#0($sp) blue 

.text	
setpixel:	
	
		
	
	#calculo da cor	 guardar no registo t1, posso usar o registo 
	#vermelho(bits 16-23), verde (bits 8-15) e azul (bits 0-7)
	
	#vermelho
	move	$t0 ,$a2	# meto o valor de RED em $t0
	sll 	$t1, $t0, 16 	#adiciona a componente vermelha
	
	#verde	
	move	$t0 ,$a3	# meto o valor de GREEN em $t0
	sll	$t0, $t0, 8	#calcula a cor verde
	or	$t1, $t1, $t0	#adiciona a componente verde
	
	#Azul
	lw	$t0 ,0($sp)	# meto o valor de BLUE em $t0
	or	$t1, $t1, $t0	#adiciona a componente azul, como o azul é nos primeiros 8 bits não é necessario fazer sll
	
	#inicializacao das variaveis importantes
	la	$t0, 0x10000000 #endereço do display
	move	$t2 ,$a0	# Numero de linhas a andar
	

	# ir para a linha	
	addi 	$t3, $0,0 	# garantir que o registo está a zero
	addi 	$t3, $t3,256 	#t3=256
	mult 	$t3, $t2 	#t3 = t3* a0 (numero de bytes a avançar para ir para a linha pretendida
	mflo 	$t3
	
	add 	$t4, $t0, $t3 	# move o endereço original para o endereço pretendido t4= endereço original+256*nlinhas
	
	# ir para coluna
	move	$t2, $a1	# Numero de colunas  a andar
	
	addi 	$t3, $0,0 	# limpar o registo t3
	addi 	$t3, $t3,4 	#t3=4
	mult 	$t3, $t2 	#t3 = t3* a1 (numero de bytes a avançar para ir para a coluna pretendida 
	mflo 	$t3
	
	add 	$t4, $t4, $t3 	#incrementa o numero de bytes necessario para ir para coluna desejada	

	
	# pinta o pixel com a cor pretendida
	sw 	$t1, 0($t4)	# coloca a cor pretendida no pixel pretendido
	jr 	$ra
