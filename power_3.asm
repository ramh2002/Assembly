.data

tab:    .asciiz  "\t"
newline:.asciiz  "\n"
Result3 : .ascii "Enter the value " 

###########################################################
		.text

# The MAIN code block

.globl main

main:

# Print result=
    	li $v0, 4
    	la $a0, Result3
    	syscall

# Get Value
    	li $v0, 5
    	syscall
        move $s0, $v0

# Calling Pow3 to calculate value of result
        jal Pow3


        P_Exit:
        li $v0, 1
    	la $a0, ($s1)
    	syscall
    	
    	li $v0, 4
    	la $a0, newline
    	syscall
    	        
    	li $v0, 10		#End Program
    	syscall


Pow3:
        li $t0,3
        li $s1,1

        Rec:
        beqz $s0, P_Exit
        mul $s1,$s1,$t0  # s1 =  
    	    	    	               
   	add $s0,$s0,-1
   
        j Rec
