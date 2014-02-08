# File: 75.s
# Programmer: Robert Morning
# Class: CS224 Final Project - Winter 2014
# Goal: Read n, k from cmdline; convert to ints; swap if n < k
# usage: spim -f 75.s <int> <int>
#
# Algorithm in C:
#  a1=a1+a2
#  a2=a1-a2
#  a1=a1-a2
#
# Register usage: t8, t9

.data
newline: .asciiz "\n"
space: .asciiz " "
usage_stmt:
  .asciiz   "\nUsage: spim -f 75.s <int> <int>\n"
error_msg:
  .asciiz   "\n!ERROR!\nUsage: spim -f 75.s <int> <int>\n"

.text
.globl main

main:
  # load the default values into registers that'll be used
  li $t8, 4
  li $t9, 6

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
  ble $t8, $t9, dont_swap
  # swap the two numbers
  xor $t9, $t9, $t8 
  xor $t8, $t9, $t8 
  xor $t9, $t9, $t8 

dont_swap:   
done:
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

  j exit

exit:
  li   $v0, 10
  li   $a0, 0
  syscall

error:
  # print error message then exit program
  la $a0, error_msg
  li $v0, 4
  syscall
  j exit # exit program

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
