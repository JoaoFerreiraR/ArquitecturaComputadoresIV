.data
pedeop: .asciiz  "1)Clear\n2)Desenhar grafico\n0)Sair\n"
pedeRGB: .asciiz  "Insira o valor de vermelho, verde e azul entre 0 e 255,separados por enter\n"
pedenome: .asciiz  "Insira o nome do ficheiro\n"
file:	.space 64

arrayChar:	.space	256 #array de caracteres que se vai transformar em inteiros 
		.align 	2  #usado para poder alinhar as 2 arrays, visto que uma vai estar mais "adiantada"
arrayInt:	.space	256 
.text

menu:
	move $a0, $0
	la   	$a0, pedeop     # load address of print heading
    	li   	$v0, 4          # specify Print String service
      	syscall               	# print heading
      	
	li	 $v0, 5         #pedir o numero ao utilizador 
      	syscall
      	add 	$t0, $v0, $zero	# guardar o numero em t1
      	
      	#verfica as opções     
      	
      	beq 	$t0, 1 clearscreen# vai para o clear
      	beq 	$t0, 2 desenha #vai para o desenhar
	beqz	$t0, SairPrograma
	
	
	
	j	menu

clearscreen:
	
	la   	$a0, pedeRGB     # load address of print heading
    	li   	$v0, 4          # specify Print String service
      	syscall               	# print heading
      	
      	li	$v0, 5             #pedir o numero ao utilizador 
      	syscall
      	add 	$a0, $v0, $zero
      	
	li	$v0, 5             #pedir o numero ao utilizador 
      	syscall
      	add 	$a1, $v0, $zero
      	
	li	$v0, 5             #pedir o numero ao utilizador 
      	syscall
      	add 	$a2, $v0, $zero
      	      	
	jal 	clear	#set pixel com cor RGB 

	j	menu
	      	

desenha:
	# pede o nome do ficheiro
	la	$a0, pedenome
	li	$v0, 4
	syscall
	li	$v0, 8
	la	$a0, file
	addi	$a1, $0, 64
	syscall
	# retira o \n do nome do ficheiro
	la	$s0, file
procura:
	lbu	$s1, 0($s0)
	beq	$s1, 0x0A, RemoveN #0x0A = \n
	addi	$s0, $s0, 1
	j 	procura
RemoveN:
	sb 	$0, 0($s0) #mete o bit \n a 0
	
	# abrir o ficheiro
	li	$v0, 13
	la	$a0, file
	li	$a1, 0		# abre o ficheiro para leitura
	li	$a2, 0
	syscall
	move	$s5, $v0
	
	# lê do ficheiro
le:	move	$a0, $s5
	la	$a1, arrayChar
	li	$a2, 256
	li	$v0, 14
	syscall
	beq	$v0, $0,AcabouLeitura
	sub	$a2, $a2, $v0
	bne	$a2, $0, le
	
AcabouLeitura:
	#pega no array de chars, de tamanho 256, e passa para um array de 256 inteiros
	li	$s3, 0
	la	$s0, arrayChar
	la	$s4, arrayInt
	jal drawaxis #aproveita para desenhar o eixo
loop:
	move	$a0, $s0
	jal	asciitoint
	sw	$v0, 0($s4)
	addi	$s0, $s0, 4
	addi	$s4, $s4, 4
	addi	$s3, $s3, 1
	bge	$s3, 64, exitLoop
	j	loop
	
exitLoop:
	la	$a0, pedeRGB
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a1, $v0
	li	$v0, 5
	syscall
	move	$a2, $v0
	li	$v0, 5
	syscall
	move	$a3, $v0
	la	$a0, arrayInt
	jal	plot
	
fecharFicheiro:
	li	$v0, 16
  	move	$a0, $s5
  	syscall
  	j	menu

SairPrograma:
	li	$v0, 10
	syscall
