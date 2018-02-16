.globl 	asciitoint
.data

test: .asciiz   "-32" #COMENTAR LINHA SE FOR PARA USAR UM ENDEREÇO PASSADO A FUNCAO MESMO

# + = ascii 43 
#para passar de algarismo char para int = subtrair por 48
.text
asciitoint:	
		##TESTE
		la $a0, test #COMENTAR LINHA SE FOR PARA USAR UM ENDEREÇO PASSADO A FUNCAO MESMO
		##FIM DE COISAS DO TESTE
		
		
		#inicializacao das variaveis importantes
		addi	$t5, $0, 10  #t5= 10, para multiplicar o segundo algarismo, das dezenas.
		
		
		#leitura dos valores na array
		lbu	$t0, 0($a0) 
		addi	$t0, $t0,-43     #t0= sinal, se for 0 é +, se for outro número, -(ou outro char)
		lbu	$t1, 1($a0) 
		addi	$t1, $t1, -48    #t1= primeiro algarismo
		lbu	$t2, 2($a0)
		addi	$t2, $t2, -48    #t2= segundo algarismo
		
		#faz a multiplicacao do 2o algarismo para dezenas e soma às unidades (ainda não tem sinal)
		mult	$t1, $t5
		mflo	$v0
		add 	$v0, $v0, $t2
		
		#verifica se o primeiro algarismo é + ou -/outro char
		#se for, sai logo da funcao, pois já está o número dado.
		beqz $t0,sair
		
		#se nao for, ou seja, se for menos, faz ainda este passo(passar para negativo)
		sub $v0,$0, $v0   # v0= 0-v0 logo passa o numero para negativo
		
	
sair:	
	jr $ra
 
