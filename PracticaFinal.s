	.data
an:	.word 0 3 3 6 1 4 6 2 5 0 3 5
ab: 	.word 0 3 4 0 2 5 0 3 6 1 4 6
coma:	.asciiz ", "
de:	.asciiz " de " 
	#asciiz "Martes, 1 de noviembre de 2016

fecha:	.space 10
dma:	.space 3
	.text
	.globl __start
__start:
	la $s2,dma
	la $a0,fecha
	li $a1,15
	li $v0,8
	syscall
	jal ordenar	#guarda en t5 dia, t6 mes, t7 annio
	jal bisiesto	#guarda en t8 1 si bisiesto, 0 si no bisiesto
	la $a0,an
	la $a1,ab
	jal modulo	#guarda en t9
	jal algoritmo	#guarda en t3
	add $t5,
	li $v0,10
	syscall
ordenar:
	li $t1,10
	li $s0,0
	li $s1,2

loop1:	addi $s0,$s0,1	#Dias introducidos $t5
	lb $t0,0($a0)
	addi $t0,$t0,-48
	addi $a0,$a0,1	
	add $t2,$t2,$t0
	beq $s0,$s1,exit1
	mul $t2,$t2,$t1
	j loop1
exit1:
	add $t5,$zero,$t2
	addi $a0,$a0,1
	li $s0,0
	li $s1,2
	li $t2,0


loop2:	addi $s0,$s0,1	#Mes introducido $t6
	lb $t0,0($a0)
	addi $t0,$t0,-48
	addi $a0,$a0,1	
	add $t2,$t2,$t0
	beq $s0,$s1,exit2
	mul $t2,$t2,$t1
	j loop2
exit2:
	addi $s2,$s2,1
	add $t6,$t2,$zero
	addi $a0,$a0,1
	li $s0,0
	li $s1,4
	li $t2,0


loop3:	addi $s0,$s0,1	#Annio introducido $t7
	lb $t0,0($a0)
	addi $t0,$t0,-48
	addi $a0,$a0,1	
	add $t2,$t2,$t0
	beq $s0,$s1,exit3
	mul $t2,$t2,$t1
	j loop3
exit3:
	add $t7,$t2,$zero
	jr $ra




algoritmo:
	li $t0,3
	li $t2,7
	addi $t7,$t7,-1 #annio menos 1(A-1)
	div $t7,$t1
	mflo $t3 	#(A-1)/100
	addi $t3,$t3,1
	srl $t3,$t3,2
	mul $t3, $t3,$t0
	srl $t4,$t7,2
	sub $t4,$t4,$t3
	div $t4,$t2
	mfhi $t4	#((A-1)/4-3*((A-1)/100+1)/4)
	div $t7,$t2
	mfhi $t3
	add $t3,$t3,$t4
	div $t5,$t2
	mfhi $t4
	add $t3,$t3,$t4
	add $t3,$t3,$t9
	div $t3,$t2
	mfhi $t3
	jr $ra

bisiesto:		#t8 lleva los bisiestos
	li $t1,100
	li $t0,400
	li $t2,4
	li $t4,0
	div $t7,$t2
	mfhi $t3
	beq $t3,$t4,bis2
	li $t8,0
	jr $ra	
bis2:
	div $t7,$t1
	mfhi $t3
	beq $t3,$t4,bis3
	li $t8,1
	jr $ra
	
bis3:
	div $t7,$t0
	mfhi $t3
	slti $t8, $t3,1
	jr $ra
	



modulo:			#en t9 se encontrará el módulo
	li $t0,1
	beq $t0,$t8, modbis
	sll $s6,$t6,2
	addi $s6,$t6,-4
	add $a0,$a0,$s6
	lw $t9,0($a0)
	jr $ra
	
modbis:
	sll $s6,$t6,2
	addi $s6,$s6,-4
	add $a1,$a1,$s6
	lw $t9,0($a1)
	jr $ra