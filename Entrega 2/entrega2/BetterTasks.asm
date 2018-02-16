		.data
STRING_T0:	.asciiz	"Main -\n"
STRING_T1:	.asciiz	"Main \\\n"
STRING_T2:	.asciiz	"Main |\n"
STRING_T3:	.asciiz	"Main /\n"
STRING_T00:	.asciiz	"Tarefa 0 -\n"
STRING_T01:	.asciiz	"Tarefa 0 \\\n"
STRING_T02:	.asciiz	"Tarefa 0 |\n"
STRING_T03:	.asciiz	"Tarefa 0 /\n"
STRING_T10:	.asciiz	"Tarefa 1 -\n"
STRING_T11:	.asciiz	"Tarefa 1 \\\n"
STRING_T12:	.asciiz	"Tarefa 1 |\n"
STRING_T13:	.asciiz	"Tarefa 1 /\n"
STRING_T20:	.asciiz	"Tarefa 2 -\n"
STRING_T21:	.asciiz	"Tarefa 2 \\\n"
STRING_T22:	.asciiz	"Tarefa 2 |\n"
STRING_T23:	.asciiz	"Tarefa 2 /\n"
.text
main:
	#codigo iniciacao
	jal Init
	# AddThread(t0)
	la	$a0, t0
	jal	AddThread
	
	# AddThread(t1)
	la	$a0, t1
	jal	AddThread
	
	# AddThread(t2)
	la	$a0, t2
	jal	AddThread
	
	# startMultiThreading()
	jal startMultiThreading
	
infinito:
	la	$a0, STRING_T0
	li	$v0, 4
	syscall
	la	$a0, STRING_T1
	li	$v0, 4
	syscall
	la	$a0, STRING_T2
	li	$v0, 4
	syscall
	la	$a0, STRING_T3
	li	$v0, 4
	syscall
	
	b infinito

end:
	li	$v0, 10
	syscall

# as tarefas
t0:
	la	$a0, STRING_T00
	li	$v0, 4
	syscall
	la	$a0, STRING_T01
	li	$v0, 4
	syscall
	la	$a0, STRING_T02
	li	$v0, 4
	syscall
	la	$a0, STRING_T03
	li	$v0, 4
	syscall
	b	t0
	
t1:
	la	$a0, STRING_T10
	li	$v0, 4
	syscall
	la	$a0, STRING_T11
	li	$v0, 4
	syscall
	la	$a0, STRING_T12
	li	$v0, 4
	syscall
	la	$a0, STRING_T13
	li	$v0, 4
	syscall
	b	t1

t2:
	la	$a0, STRING_T20
	li	$v0, 4
	syscall
	la	$a0, STRING_T21
	li	$v0, 4
	syscall
	la	$a0, STRING_T22
	li	$v0, 4
	syscall
	la	$a0, STRING_T23
	li	$v0, 4
	syscall
	b	t2
