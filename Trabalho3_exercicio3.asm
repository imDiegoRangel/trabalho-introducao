# Disciplina: Arquitetura e Organização de Processadores
# Atividade: Avaliação 03 – Procedimentos em Linguagem de Montagem
# Exercício 03
# Alunos: Diego Bourguignon Rangel e Miguel Bertonzin

.data  # segmento de dados

Vetor_A: .word 0, 0, 0, 0, 0, 0, 0, 0
msg1: .asciiz "Leitura dos elementos do Vetor: "
msg2: .asciiz "\nEntre com A["
msg3: .asciiz "]: "

.text 				# segmento de código (programa)

	li $v0, 4 		# chamada 4 para printar a string
	la $a0, msg1 		# carrega a string
	syscall
	
	la $s6, Vetor_A 	# $s6 contém o endereço-base de Vetor_A[].
	addi $s0, $zero, 0 	# i=0
	
	j Entrada 		# goto Entrada
	
procedimento: 	
	sub $sp, $sp, 16    	# ajusta a pilha para 4 valores
	sw  $s1, 12($sp)     	# salva o conteúdo de $s0
        sw  $t1, 8($sp)     	# salva o conteúdo de $t1
        sw  $t0, 4($sp)     	# salva o conteúdo de $t0
        sw  $s0, 0($sp)     	# salva o conteúdo de $s0
        
        addi $s0, $zero, 0 	# i=0
        
inicio:	
	slti $t0, $s0, 8 	# se i<8(s0<imediato[8]) então $t0=1 senão $t0=0
        beq $t0, $zero, Saída   # se $t0=0 então goto Saída
	
	add $t1, $s0, $s0 	# $t1 = 2.i
	add $t1, $t1, $t1 	# $t1 = 4.i
	add $t1, $t1, $s6 	# $t3 = end.base + 4.i (deslocamento) = end. de save[i] (VETOR A)	
	
	lw $s1, 0($t1) 		# s1 recebe end absoluto 
	beqz $s1, contagem 	# se s1 = 0, vai para contagem
	
	addi $s0, $s0, 1	# i++ (do laço for)
	
	j inicio 		# volta para inicio
	
contagem: 
	addi $v0, $v0, 1 	# v0 + 1

	addi $s0, $s0, 1 	# i++ (do laço for)
	j inicio	
	
Saída:	
	lw  $s0, 0($sp)     	# carrega o conteúdo de $s0	
	lw  $t0, 4($sp)     	# carrega o conteúdo de $t0
	lw  $t1, 8($sp)     	# carrega o conteúdo de $t1
	lw  $s1, 12($sp)     	# carrega o conteúdo de $s0
	add $sp, $sp, 16   	# ajusta a pilha para 4 valores
	
	jr  $ra             	# retorna do procedimento
		
Entrada:	

	slti $t0, $s0, 8 	# se i<8(s0<imediato[8]) então $t0=1 senão $t0=0
       	beq $t0, $zero, main 	# se $t0=0 então goto main
 
	li $v0, 4 		# chamada 4 para printar a string
	la $a0, msg2 		# carrega a string
	syscall
	
	li $v0, 1 		# chamada 1 para printar um valor inteiro
	move $a0, $s0 		# movendo o valor de $s0 para $a0
	syscall 
 
	li $v0, 4 		# chamada 4 para printar a string
	la $a0, msg3 		# carrega a string
	syscall
	
	li $v0, 5 		# chamada 5 para escrita do segundo inteiro
	syscall 
	move $s1, $v0 		# utilizando a pseudo para salvar o valor em um registrador diferente

	add $t1, $s0, $s0 	# $t1 = 2.i
	add $t1, $t1, $t1 	# $t1 = 4.i
	add $t1, $t1, $s6 	# $t3 = end.base + 4.i (deslocamento) = end. de save[i] (VETOR A)

	sw $s1, 0($t1) 		# endereco $t3 recebe o valor digitado de $s1.

	addi $s0, $s0, 1 	# i++ (do laço for)
	
	j Entrada 		# goto Entrada


main:
	sub $v0, $v0, $v0 	# subtração de v0 com v0, para garantir que fique zerado.
			
 	jal procedimento    	# chama o procedimento
 		
 	move $a0, $v0 		# passando o valor da contagem para a0
 		
 	li $v0, 1 		# chamada 1 para printar um valor inteiro
 	syscall 
