      .data
head: .word 0
      .text
	
AddThread:
	# Guardar o conteudo de $a0 (endereco de inicio de tarefa)
	addi 	$sp, $sp, -4	# Decrementar sp em 4 bytes
	sw 	$a0, 0($sp) 	# Armazenar $a0

	# Alocar espaco relativo a esta thread
	li 	$a0, 140	# Número de bytes a alocar na heap
	li 	$v0, 9 		# prepara syscall allocate heap memory
	syscall			# v0 contem endereco de memoria alocada
	
	sw 	$zero, 0($v0)	# Ponteiro para next a NULL 
	
	# Carrega o $a0 passado e guarda-o no inicio do bloco alocado
	lw 	$a0, 0($sp)	# Obtem a0 da stack, endereço de inicio de tarefa
	addi 	$sp, $sp, 4	# Stack pointer volta ao sitio original
	sw 	$a0, 4($v0)	# Guarda o parâmetro de entrada na segunda posição
	
	# Preenche lista ligada
	la 	$t0, head	# t0 aponta para o primeiro elemento
	
FindLastNode:
	lw	$t1, 0($t0)	# t1 e o endereco do elemento apontado por t0
	beqz	$t1, AddNode	# Se o proximo elemento for NULL
	add	$t0, $t1, $zero	# t0 passa a ser o proximo elemento da lista ligada
	j	FindLastNode
	
AddNode:
	sw	$v0, 0($t0)	# Actualiza a lista ligada	
	jr	$ra
