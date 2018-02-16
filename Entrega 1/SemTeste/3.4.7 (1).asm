.data
pedeop: .asciiz  "1) clear\n2)  desenhar grafico\n"
pedeRGB: .asciiz  "Insira o valor de vermelho, verde e azul entre 0 e 255\n"
pedenome: .asciiz  "Insira o nome do ficheiro"
file:	.space 64

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
      	
      	beq 	$t0, 1 apaga# se o utilizador meteu 1 apagar
      	beq 	$t0, 2 desenha# se o utilizador meteu 2 desenha

	
	
	
	j	menu

apaga:
	
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

	la   	$a0, pedenome     # load address of print heading
    	li   	$v0, 4          # specify Print String service
      	syscall               	# print heading
      	
      	li	$v0, 8             #pedir o numero ao utilizador 
      	la	$a0, file	#buffer
      	addi	$a1,$0,64	#tamanho maximo do que é escrito
      	syscall
      	#FALTA ABRIR O FICHEIRO
      	
      	jal 	drawaxis
      	
      	la   	$a0, pedeRGB     # load address of print heading
    	li   	$v0, 4          # specify Print String service
      	syscall               	# print heading
      	
      	li	$v0, 5             #pedir o numero ao utilizador 
      	syscall
      	add 	$a1, $v0, $zero
      	
	li	$v0, 5             #pedir o numero ao utilizador 
      	syscall
      	add 	$a2, $v0, $zero
      	
	li	$v0, 5             #pedir o numero ao utilizador 
      	syscall
      	add 	$a3, $v0, $zero
      	
      	#MAGIA
      	
      	#FAZ PLOT
      	j	menu
      	
