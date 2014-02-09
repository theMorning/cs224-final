# File: 95.s
# Programmer: Robert Morning
# Class: CS224 Final Project - Winter 2014
# Goal: Write a function to display Pascal's Triangle as a right triangle for rows
#       0..n on the screen.
# usage: spim -f 95.s <int> <int>
#
# Register usage: t8 = n, t9 = k in main
#

.data
newline: .asciiz "\n"
space: .asciiz " "
usage_stmt:
  .asciiz   "\nUsage: spim -f 95.s <int> <int>\n"
error_msg:
  .asciiz   "!ERROR!\nUsage: spim -f 95.s <int> <int>\n"
choose_msg:
  .asciiz   "C(n,k) = n!/( (n-k)!*k! ) = "

.text
.globl main

main:
  # load the default values into registers that'll be used
  li $t8, 6
  li $t9, 4

  # grab command line stuff - a0 is arg count and a1 points to list of args
  move $s0, $a0
  move $s1, $a1

  # check if not three arguments are given
  li $t0, 3 
  bne $a0, $t0, dont_swap		# Go to location after converting cmd
					# line arguments
     
  # parse the first number
  lw $a0, 4($s1)
  jal atoi
  move $t8, $v0
     
  # parse the second number
  lw $a0, 8($s1)
  jal atoi
  move $t9, $v0

  # Check order of numbers
  bgt $t8, $t9, done
  # swap the two numbers
  xor $t9, $t9, $t8 
  xor $t8, $t9, $t8 
  xor $t9, $t9, $t8 

done:
# Print initial values
  # move the result from t8 to v0 to print it
  move $a0, $t8     
  li $v0, 1
  syscall

  # print a space
  la $a0, space     
  li $v0, 4
  syscall

  # move the result from t9 to v0 to print it
  move $a0, $t9     
  li $v0, 1
  syscall

  # print a newline
  la $a0, newline     
  li $v0, 4
  syscall

# Call fac and print again
  move $a0, $t8			# store first number into $a0 for fac function
  jal fac			# call fac
  
  # move the result from t8 to v0 to print it
  move $a0, $v0
  li $v0, 1
  syscall

  # print a space
  la $a0, space     
  li $v0, 4
  syscall

  move $a0, $t9			# store second number into $a0 for fac function
  jal fac			# call fac
  
  # move the result of fac to $a0 for printing
  move $a0, $v0
  li $v0, 1
  syscall

  # print a space
  la $a0, space     
  li $v0, 4
  syscall

  # print a newline
  la $a0, newline     
  li $v0, 4
  syscall

# Set up arguments for cnk, call the function and print
  # print choose message
  la $a0, choose_msg
  li $v0, 4
  syscall

  # function call and parameters
  move $a0, $t8
  move $a1, $t9
  jal cnk

  # print the result
  move $a0, $v0
  li $v0, 1
  syscall

  # print newline
  la $a0, newline     
  li $v0, 4
  syscall

# print a single row of pascals triangle
  move $a0, $t8			# set n as parameter for displayRow
  jal displayRow		# call displayRow

  # print newline
  la $a0, newline     
  li $v0, 4
  syscall

# print rows of pascals triangle
  move $a0, $t8			# set n as parameter for displayRow
  jal displayTriangle		# call displayRow

# print last newline and end program
  la $a0, newline     
  li $v0, 4
  syscall

  j exit

exit:
  li   $v0, 10
  li   $a0, 0
  syscall

dont_swap:
  # print error message then continue program
  la $a0, error_msg
  li $v0, 4
  syscall
  j done

error:
  # print error message then exit program
  la $a0, error_msg
  li $v0, 4
  syscall
  j exit # exit program

#======== FAC FUNCTION
# Registers used:
#   $a0 function parameter the number that factorial will be calculated for
#   $v0 the return value, the result of the multiplication
#
# Algorithm in C:
#  int fac(n) {
#    int product = 1;
#    for( int i = 1 to n )
#      product = product * i;
#    return product;
#  }
#

fac:
  addi $v0, $zero, 1		# init return value to 1

loop_fac:
  beqz $a0, end_fac		# if we've decremented to zero end the loop
				# while( a0 > 0)
  mul $v0, $v0, $a0		# v0 = v0 * a0
  sub $a0, $a0, 1		# a0 = a0 - 1
  j loop_fac

end_fac:
  jr $ra			# return to calling function

#======== C(N,K) FUNCTION
# Registers used:
#   $a0 function parameter n
#   $a1 function parameter k
#   $a2 local n-k
#   $v0 the return value, the result
#
#  int cnk(n,k) {
#    int nMinusk = n - k;
#    int n_fac = fac(n);
#    int k_fac = fac(k);
#    int nMinusk_fac = fac(nMinusk);
#    return n_fac / ( nMinusk_fac * k_fac );
#  }
#
#
# Stack: 	      32+--------+
#			| n-k!	 +
#		     $fp+--------+
#			| k!     |
#		      24+--------+
#			| n!     |
#		      20+--------+
#			| $ra    |
#		      16+--------+
#			| $fp    |
#		      12+--------+
#			|        |
#		       8+--------+
#			|        |
#		       4+--------+
#			|        |
#		     $sp+--------+

cnk:
  addi $sp, $sp, -32		# stack frame is 32 bytes long
  sw $ra, 16($sp)		# save return address ra
  sw $fp, 12($sp)		# save old frame pointer
  addi $fp, $sp, 28		# set up frame pointer to first addressable word

  sub $a2, $a0, $a1		# set (n - k)

  jal fac			# call fac
  				# store n is $a0 so call fac function
  
  # move the result of n! to stack
  sw $v0, 20($sp)

  move $a0, $a1			# store k into $a0 for fac function
  jal fac			# call fac

  # move the result of k! to stack
  sw $v0, 24($sp)

  move $a0, $a2			# store n-k into $a0 for fac function
  jal fac			# call fac

  # move the result of (n-k)! to stack
  sw $v0, 28($sp)

  lw $t0, 24($sp)		# grab k! from the stack
  mul $v0, $v0, $t0		# (n-k)! * k!
  
  lw $t0, 20($sp)		# grab n! from the stack
  div $t0, $v0			# n! / result of (n-k)! * k!

  mflo $v0			# store the quotient as the return value

  # restore values from stack
  lw $ra, 16($sp)		# restore return address
  lw $fp, 12($sp)		# restore frame pointer
  addi $sp, $sp, 32		# pop stack frame

  jr $ra			# go back to calling function

#======== DISPLAYROW FUNCTION
# Registers used:
#   $a0 function parameter n
#   $a1 local iterator k
#   this function has no return value
#
# Stack: 	      32+--------+
#			| n	 +
#		     $fp+--------+
#			| k      |
#		      24+--------+
#			|        |
#		      20+--------+
#			| $ra    |
#		      16+--------+
#			| $fp    |
#		      12+--------+
#			|        |
#		       8+--------+
#			|        |
#		       4+--------+
#			|        |
#		     $sp+--------+

displayRow:
  move $a1, $zero		# set iterator to 0

displayRow_loop:
  blt $a0, $a1, displayRow_end # while(k < n)

  # function call and parameters
  addi $sp, $sp, -32		# stack frame is 32 bytes long
  sw $ra, 16($sp)		# save return address ra
  sw $fp, 12($sp)		# save old frame pointer
  addi $fp, $sp, 28		# set up frame pointer to first addressable word

  # store n and k to the stack because these registers are used in cnk function
  sw $a0, 28($sp)
  sw $a1, 24($sp)

  jal cnk			# call cnk with current n and k as parameters

  # print the result
  move $a0, $v0
  li $v0, 1
  syscall
  
  # print a space
  la $a0, space     
  li $v0, 4
  syscall
  
  # restore values from stack n, k, ra, fp, sp
  lw $a0, 28($sp)
  lw $a1, 24($sp)
  lw $ra, 16($sp)		# restore return address
  lw $fp, 12($sp)		# restore frame pointer
  addi $sp, $sp, 32		# pop stack frame

  addi $a1, $a1, 1		# k++
  j displayRow_loop		# return to loop start

displayRow_end:
  jr $ra

#======== DISPLAYTRIANGLE FUNCTION
# Registers used:
#   $a0 function parameter n
#   $a1 local iterator i this is passed to displayRow as parameter n
#   this function has no return value
#
# Stack: 	      32+--------+
#			| n	 +
#		     $fp+--------+
#			| i      |
#		      24+--------+
#			|        |
#		      20+--------+
#			| $ra    |
#		      16+--------+
#			| $fp    |
#		      12+--------+
#			|        |
#		       8+--------+
#			|        |
#		       4+--------+
#			|        |
#		     $sp+--------+

displayTriangle:
  move $a1, $zero		# set iterator to 0

displayTriangle_loop:
  blt $a0, $a1, displayTriangle_end # while(i < n)

  # function call and parameters
  addi $sp, $sp, -32		# stack frame is 32 bytes long
  sw $ra, 16($sp)		# save return address ra
  sw $fp, 12($sp)		# save old frame pointer
  addi $fp, $sp, 28		# set up frame pointer to first addressable word

  # store n and k to the stack because these registers are used in cnk function
  sw $a0, 28($sp)
  sw $a1, 24($sp)

  move $a0, $a1			# use the iterator value as the n parameter of function
  jal displayRow		# call displayRow with current i parameter

  # print newline
  la $a0, newline     
  li $v0, 4
  syscall

  # restore values from stack n, k, ra, fp, sp
  lw $a0, 28($sp)
  lw $a1, 24($sp)
  lw $ra, 16($sp)		# restore return address
  lw $fp, 12($sp)		# restore frame pointer
  addi $sp, $sp, 32		# pop stack frame

  addi $a1, $a1, 1		# i++
  j displayTriangle_loop	# return to loop start

displayTriangle_end:
  jr $ra

#======== ATOI FUNCTION 

atoi:
    move $v0, $zero
     
    # detect sign
    li $t0, 1
    lbu $t1, 0($a0)
    bne $t1, 45, digit
    li $t0, -1
    addu $a0, $a0, 1

digit:
    # read character
    lbu $t1, 0($a0)
    beqz $t1, finish # if the address is 0 the null character has been reached
     
    # finish when non-digit encountered, goto error
    bltu $t1, 48, error
    bgtu $t1, 57, error
     
    # translate character into digit
    subu $t1, $t1, 48
     
    # multiply the accumulator by ten
    li $t2, 10
    mult $v0, $t2
    mflo $v0
     
    # add digit to the accumulator
    add $v0, $v0, $t1
     
    # next character
    addu $a0, $a0, 1
    b digit

finish:
    mult $v0, $t0
    mflo $v0
    jr $ra

#================================================
