	.data
display:.word 	0x10000000
file:	.asciiz	"C:/Users/zkdev/Desktop/AC/entrega1/rift.pgm"
buffer:	.space  256
size:	.word	4096 	#max size of display (64x64)
Erro: .asciiz  "erro ao ler do ficheiro"

	.text
	
	li	$v0, 13		#open file
	la	$a0, file 	#address of filename
	li	$a1, 0		#flags
	li	$a2, 0		#mode
	syscall
	
	move	$s0, $v0	#s0=file descriptor
	
	li	$t0, 0		#inicialização do contador contador = t0
	la	$t1, display	#endereço onde está o endereço do display
	lw	$t1, ($t1)	#endereço do display 
	la	$t2, buffer	#t2= endereço do buffer 

	lw	$t5, size	#t5=size 
	
loop1:	beq	$t0, 13 cleancont	# para passar à frente os primeiros valores
	li	$v0, 14		# read from file job
	move	$a0, $s0	# a0 has file descriptor
	la	$a1, ($t2)
	li	$a2, 1		# read 1 byte
	syscall
	bltz	$v0, erro
	
	addi	$t0, $t0, 1 # increment counter
	
	j	loop1
	
cleancont:
	li	$t0, 0	#limpar o contador t0
	j	loop2
			
loop2:	li	$v0, 14		# read from file job
	move	$a0, $s0	# a0 has file descriptor
	la	$a1, ($t2)
	li	$a2, 1		# read 1 byte
	syscall
	bltz	$v0, erro
	beqz 	$v0, loop3	# se já leu o ficheiro todo começa a imprimir preto
	
	#prepara a cor para fazer display identico ao RGB	
	
	lb	$t3, ($t2)	#composes on buffer
	sll	$t4, $t3, 8 	#shift left 8 bits (2^8 = 256)
	add	$t4, $t4, $t3	#store the value on $t4
	sll	$t4, $t4, 8	#shift left 8 bits (2^8 = 256)
	add	$t4, $t4, $t3	#store the value 
	
	sw	$t4, 0($t1)	#set display
	
	addi	$t1, $t1, 4 # avança pixel
	addi	$t0, $t0, 1 # incrementa o contador
	blt	$t0, $t5, loop2
	

	
	j 	exit
	
	
loop3:
	
	sw	$0, 0($t1)	#grava a cor preta no ecra
	
	addi	$t1, $t1, 4 # avança pixel
	addi	$t0, $t0, 1 # incrementa o contador
	blt	$t0, $t5, loop3 # t5 tem o valor de pixeis existentes 
	
	j	exit
	
erro:
	
	la   	$a0, Erro     # load address of print heading
    	li   	$v0, 4          # specify Print String service
      	syscall               	# print heading	

	j	exit
	
exit:
	li	$v0, 10 # exit 
	syscall
	
