.globl Init
.data
msginit: .asciiz  "Iniciando Kernel Multi-tarefa\n"
.text


Init: 

	
	la   	$a0, msginit     # load address of print heading
    	li   	$v0, 4          # specify Print String service
      	syscall               	# print heading	

	jr	$ra
	
