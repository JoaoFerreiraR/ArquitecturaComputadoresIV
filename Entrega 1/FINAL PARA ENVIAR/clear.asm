.globl 	clear
.data

.text
	
	
clear:

	
	#vermelho
	move	$t0 ,$a0	# meto o valor de RED em $t0
	sll 	$t1, $t0, 16 	#adiciona a componente vermelha
	
	#verde	
	move	$t0 ,$a1	# meto o valor de GREEN em $t0
	sll	$t0, $t0, 8	#calcula a cor verde
	or	$t1, $t1, $t0	#adiciona a componente verde
	
	#Azul
	move	$t0 ,$a2	# meto o valor de BLUE em $t0
	or	$t1, $t1, $t0	#adiciona a componente azul, como o azul é nos primeiros 8 bits não é necessario fazer sll
	
	#inicializacao das variaveis importantes
	addi	$t0, $0,0 	# garantir que o registo está a zero
	addi	$t0, $0, 0x10000000 #endereço do display
	
	
	addi 	$t3, $0,0 	# garantir que o registo está a zero
	addi 	$t3, $t3,64 	#t3=64
	mult 	$t3, $t3 	#t3 = t3*t3  numero total de bytes no ecra
	mflo 	$t3
	
	addi	$t5, $0, 0	#$t5=0
	
pintar: beq 	$t5, $t3, sair
	sw 	$t1, 0($t0)	# coloca a cor pretendida no pixel pretendido
	addi	$t0, $t0, 4	# ando um byte para a frente
	addi	$t5, $t5, 1	#contador do pixel onde estamos
	j	pintar		# se ainda não percorreu o todo o eccra volta a pintar
	
sair:	jr $ra
