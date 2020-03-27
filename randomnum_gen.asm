# Main program, asks for number of N and starting seed
# $s5 is count, $s4 is N, $t3 is starting r and will change to new r as subroutine is used

.data
	
	responseLow: 		.asciiz " Hot  Guess again:\n "
	responseRight: 		.asciiz "Congratulations you guessed my number correctly!\n"
	responseHigh: 		.asciiz " COLD Guess Again: \n"
	prompt: 		.asciiz "Please enter an integer: "
	
 .text

.globl  main
main:

	# get guess ----------------
 # Prompt for the integer to enter
 li $v0, 4
 la $a0, prompt
 syscall
  
# Read the integer and save it in $s0
 li $v0, 5
 syscall
 move $s0, $v0

jal numGen  

 
	li $a1, 4
	move $a1, $v0
	
	# --------------------------
	jal printResponse
	#beq $v0, 1, exit # If the guess is correct, exit the application.
  
		
# Random Number Generation
numGen:
    addi $a1, $zero , 10
    addi $v0, $zero , 42
    syscall
    addi $v0, $zero, 1
    syscall
    addi $v0, $zero, 42
    syscall
    addi $v0, $zero, 1
    syscall
    move $a2, $v0
    						
# PROCEDURE printResponse
# ARGUMENTS $a0 number to guess
#			$a1 number guessed
# RETURNS   $v0 Result. ( 0 = failure, 1 = success )


printResponse:
	blt $s0, $a1, tooLow 	# if guess <  numToGuess jump to responseLow
	bgt $s0, $a1, tooHigh 	# if guess >  numToGuess jump to toohigh
	beq $s0, $a1, justRight	# if guess == numToGuess jump to justRight
							
   
tooHigh:
    	# print responseHigh message
	li $v0, 4
	la $a0, responseHigh
	syscall
	jal main
tooLow:
    	# print responseLow message
	li $v0, 4
	la $a0, responseLow
	syscall
	jal main
		
justRight:
	# print responseRight message
	li $v0, 4
	la $a0, responseRight
	syscall
	jal exit

exit:
	# exit program -------------
	li $v0, 10
	syscall
	# -------------------------- 
	
 # Exit the program		
		