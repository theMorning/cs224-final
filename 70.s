# File: 70.s
# Programmer: Robert Morning
# Class: CS224 Final Project - Winter 2014
# Goal: Read n, k from cmdline; convert to ints; swap if n < k
# usage: spim -f 70.s <int> <int>
#
# Algorithm in C:
#
# Register usage: t8, t9

.data
newline: .asciiz "\n"
usage_stmt:
  .asciiz   "\nUsage: spim -f 70.s <int> <int>\n"

.text
.globl main

main:

# grab command line stuff - a0 is arg count and a1 points to list of args
  move $s0, $a0
  move $s1, $a1

  # zero out these registers just to be safe
  move $s2, $zero
  move $s3, $zero
  move $s4, $zero
     
  # check if less than three arguments are given
  li $t0, 3 
  blt $a0, $t0, set_default
     
  # parse the first number
  lw $a0, 4($s1)
  jal atoi
  move $t8, $v0
     
  # parse the second number
  lw $a0, 8($s1)
  jal atoi
  move $t9, $v0
   
done:
  # move the result from t0 to v0 to print it
  move $a0, $t8     
  li $v0, 1
  syscall

  la $a0, newline     
  li $v0, 4
  syscall

  move $a0, $t9     
  li $v0, 1
  syscall

  la $a0, newline     
  li $v0, 4
  syscall

  j exit

set_default:  
  # load the default values into registers that'll be used
  jr $ra			# go back to the caller

exit:
  li   $v0, 10
  li   $a0, 0
  syscall

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
     
    # finish when non-digit encountered
    bltu $t1, 48, finish
    bgtu $t1, 57, finish
     
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
