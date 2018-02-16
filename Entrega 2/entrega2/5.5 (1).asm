.kdata
.ktext 0x80000180

	# Verifica a causa da interrupção
	mfc0 	$k0, $13 		# get cause register para k0
	andi  	$k0, $k0, 0x00000300 	# Se os bits 8 ou 9 forem 1
	beq 	$k0, $zero, stop_i	# Caso a interrupção nao seja causada pelo teclado, para
	# Verifica se current está definido
	lw	$k1, current		# Obtem endereco de memoria referente a thread
	beq	$k1, $zero, getHead	# Caso o endereco nao esteja definido, salta para getHead
	b	save_reg
	# Adiciona 4 para depois voltar para a instrução seguinte
stop_i:	mfc0 	$k0, $14		# Obtem registo EPC
	addiu 	$k0, $k0, 4		# Incrementa 4 para retornar à proxima instrução
	mtc0 	$k0, $14
	b	iclean			# Termina a interrupt

save_reg:
	# Adiciona 4 para depois voltar para a instrução seguinte
	mfc0 	$k0, $14		# Obtem registo EPC
	addiu 	$k0, $k0, 4		# Incrementa 4 para retornar à proxima instrução
	# Guarda todos os registos
	sw	$k0, 4($k1)		# Guarda o endereco de continuacao de tarefa
	sw	$at, 8($k1)
	sw	$v0, 12($k1)
	sw	$v1, 16($k1)
	sw	$a0, 20($k1)
	sw	$a1, 24($k1)
	sw	$a2, 28($k1)
	sw	$a3, 32($k1)
	sw	$t0, 36($k1)
	sw	$t1, 40($k1)
	sw	$t2, 44($k1)
	sw	$t3, 48($k1)
	sw	$t4, 52($k1)
	sw	$t5, 56($k1)
	sw	$t6, 60($k1)
	sw	$t7, 64($k1)
	sw	$s0, 68($k1)
	sw	$s1, 72($k1)
	sw	$s2, 76($k1)
	sw	$s3, 80($k1)
	sw	$s4, 84($k1)
	sw	$s5, 88($k1)
	sw	$s6, 92($k1)
	sw	$s7, 96($k1)
	sw	$t8, 100($k1)
	sw	$t9, 104($k1)
	#sw	$k0, 108($k1)
	#sw	$k1, 112($k1)
	sw	$gp, 116($k1)
	sw	$sp, 120($k1)
	sw	$fp, 124($k1)
	sw	$ra, 128($k1)
	mfhi	$k0			# Obtem valor de hi
	sw	$k0, 132($k1)
	mflo	$k0			# Obtem valor de lo
	sw	$k0, 136($k1)
	
	# Passa para o próximo elemento da lista ligada
	lw	$k1, 0($k1)		# Obtem o endereco do proximo elemento
	bne	$k1, $zero, iend	# Se for null, obtem o primeiro endereco da lista
	
getHead:lw	$k1, head		# Obtem o endereco relativo a primeira thread
	bne	$k1, $zero, iend	# Se head for 0, então nao existem threads e termina a interrupt
	b	stop_i			# Termina a interrupt




iend:
	# Actualiza current para o proximo elemento da lista ligada
	sw	$k1, current
	###
	lw	$k0, 136($k1)
	mtlo	$k0
	lw	$k0, 132($k1)
	mthi	$k0
	lw	$ra, 128($k1)
	lw	$fp, 124($k1)
	lw	$sp, 120($k1)
	lw	$gp, 116($k1)
	#lw	$k1, 112($k1)
	#lw	$k0, 108($k1)
	lw	$t9, 104($k1)
	lw	$t8, 100($k1)
	lw	$s7, 96($k1)
	lw	$s6, 92($k1)
	lw	$s5, 88($k1)
	lw	$s4, 84($k1)
	lw	$s3, 80($k1)
	lw	$s2, 76($k1)
	lw	$s1, 72($k1)
	lw	$s0, 68($k1)
	lw	$t7, 64($k1)
	lw	$t6, 60($k1)
	lw	$t5, 56($k1)
	lw	$t4, 52($k1)
	lw	$t3, 48($k1)
	lw	$t2, 44($k1)
	lw	$t1, 40($k1)
	lw	$t0, 36($k1)
	lw	$a3, 32($k1)
	lw	$a2, 28($k1)
	lw	$a1, 24($k1)
	lw	$a0, 20($k1)
	lw	$v1, 16($k1)
	lw	$v0, 12($k1)
	lw	$at, 8($k1)
	lw	$k0, 4($k1)	# Obtem o endereco de continuacao de tarefa
	mtc0 	$k0, $14
	#baseado no codigo do prof ficha 4
iclean:	mtc0 	$zero , $13
	mfc0 	$k0 , $12
	andi 	$k0 , 0xfffd
	ori 	$k0 , 0x0001
	mtc0 	$k0 , $12
	eret 
	
