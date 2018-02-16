.globl	plot
.data
.text
plot:
	# Guardar alguns valores para pilha, sndo o mais importante ra
	addi	$sp, $sp, -32
	sw	$s0, 28($sp) #estes valores serao todos 0 excepto o endereço ra da funcao que chamou esta
	sw	$s1, 24($sp)
	sw 	$s2, 20($sp)
	sw	$s3, 16($sp)
	sw	$s4, 12($sp)
	sw	$s5, 8($sp)
	sw	$ra, 4($sp)

