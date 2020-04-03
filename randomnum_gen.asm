# random number generator
# it will generate 10 random numbers between 0 and 100

.data
# Create a string to separate the 100 numbers with a space
spacestr: 		.asciiz " " 
responseLow: 		.asciiz " Hot  Guess again:\n "
responseLow_Hotter:     .asciiz " More than 5% less than 10% HOT \n "  
responseHigh_Colder:     .asciiz " More than 5% less than 10% COLD \n "  
responseLow_hot:        .asciiz " Number is less than 5% very hot \n"
responseRight: 		.asciiz " Congratulation - Random number matched with User input !\n"
responseHigh: 		.asciiz " COLD Guess Again: \n"
responseHigh_Cold: 	.asciiz " COLD Guess Again less than 5% Very Cold: \n"
prompt: 		.asciiz "Please enter an integer: "
	

.text
##############################################################################
# seed the random number generator
##############################################################################

# get the time
li	$v0, 30		# get time in milliseconds (as a 64-bit value)
syscall

move	$t0, $a0	# save the lower 32-bits of time

# seed the random generator (just once)
li	$a0, 1		# random generator id (will be used later)
move 	$a1, $t0	# seed from time
li	$v0, 40		# seed random number generator syscall
syscall

##############################################################################
# seeding done
##############################################################################

# generate 10 random integers in the range 100 from the 
# seeded generator (whose id is 1)
li	$t2, 11		# max number of iterations + 1
li	$t3, 0		# current iteration number

LOOP:
li	$a0, 1		# as said, this id is the same as random generator id
li	$a1, 100	# upper bound of the range
li	$v0, 42		# random int range
syscall
move $t5, $a0

# $a0 now holds the random number

# loop terminating condition
addi	$t3, $t3, 1	# increment the number of iterations
beq	$t3, $t2, EXIT	# branch to EXIT if iterations is 10

# $a0 still has the random number
# print it
li	$v0, 1		# print integer syscall
syscall
 
 
# print a space
la	$a0, spacestr	# load the address of the string (pseudo-op)	
li	$v0, 4		# print string syscall
syscall


 # Prompt for the integer to enter
 li $v0, 4
 la $a3, prompt
 syscall
  
# Read the integer and save it in $s0
 li $v0, 5
 syscall
 move $t4, $v0
 
 printResponse:
	blt $t4, $t5, tooLow 	# if guess <  numToGuess jump to responseLow
	bgt $t5, $t4, tooHigh 	# if guess >  numToGuess jump to toohigh
	beq $t4, $t5, justRight	# if guess == numToGuess jump to justRight
	
tooHigh:
    	# print responseHigh message
    	sub $t7, $t4,$t5
    	add $t4,$t4,$t5
    	move $t8, $t4
    	DIV $t7,$t7, $t8
    	mfhi $a2
    	mflo $s2    	
    	li $a1, 100
    	mult $s2,$a1
    	bleu $a2,5,High_Cold	
    	bgt $a2,5, High_Colder   	
	li $v0, 4
	la $a0, responseHigh
	syscall
	jal LOOP
tooLow:
    	# print responseLow message
    	sub $t7, $t5,$t4
    	add $t5,$t5,$t4
    	move $t8, $t5
    	DIV $t7,$t7, $t8
    	mfhi $a2
    	mflo $s2    	
    	li $a1, 100
    	mult $s2,$a1
    	bleu $a2,5,Low_hot
    	bgt $a2,5, LowHotter	    	
	li $v0, 4
	la $a0, responseLow
	syscall	
	jal LOOP

High_Colder:
        bleu $a2,10,High_Cold_10
	li $v0, 4
	la $a0, responseHigh
	syscall
	jal LOOP     
	
High_Cold_10:		
     	li $v0, 4
	la $a0, responseHigh_Colder
	syscall	
	jal LOOP   	    

Low_hot:
	li $v0, 4
	la $a0, responseLow_hot
	syscall	
	jal LOOP

Lower_Hot:
        bleu $a2, 10 , LowHotter

LowHotter:
	bleu $a2,10,Low_Hot_10
	li $v0, 4
	la $a0, responseLow
	syscall	
	jal LOOP	

Low_Hot_10:		
     	li $v0, 4
	la $a0, responseLow_Hotter
	syscall	
	jal LOOP          		        		
	
High_Cold:
	li $v0, 4
	la $a0, responseHigh_Cold
	syscall	
	jal LOOP
		
			
justRight:
	# print responseRight message
	li $v0, 4
	la $a0, responseRight
	syscall
	jal EXIT
		
	
##############################################################################
# Tell MARS to exit the program
##############################################################################
EXIT:
li	$v0, 10		# exit syscall
syscall
