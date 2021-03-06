# cs224-final

## Goal
Applying skills and concepts from labs 1 - 7 into a MIPS program

## Milestones
* Week 4  70%  - read n,k from cmdline; convert to ints; swap if n < k.
* Week 5  75%  - set n=6,k=4 as default; exit if args are not numbers 
* Week 6  80%  - compute n! and k!
  * Use loop
  * Use MUL instruction to compute product
  * Call fac using MIPS jal instruction
  * Follow parameter passing convention
    * Load n into $a0 before making the call
    * Put n! in $v0 before returning
  * Return to main using MIPS jr $ra instruction
* Week 7  85%  - compute C(n,k) = n!/((n-k)!k!).
  * Use MIPS DIV instruction, result of DIV is in LO so use MFLO to grab it

   ```DIV rs, rt    # the quotient is stored in LO```
   
   ```MFLO rd       # grab the quotient```
  * Name function cnk
  * Pass 'n' to cnk in $a0, pass k in $al, and return in $v0
  * Call fac function
  * Save $ra to stack frame to keep it from being overwritten
  * Save result from fac(n), fac(k), and fac(n-k) onto the stack

   ```sw $v0, 0($fp) # store n! on stack for safekeeping```
* Week 8  90%  - display row n of Pascal's triangle for k = 0 to n. 
  * Name function displayRow
  * Write a loop that goes from k=0 to n
  * Within the loop display the return value for cnk(n,k)
* Week 9  95%  - display all rows i of Pascal's triangle, i = 0 to n.
  * Name function displayTriangle
  * Wrtie a loop that goes from i=0 to n
  * Call displayRow function
* Week 10 100%  - write a recursive function to compute C(n,k)
  * Optimize recursive function

### Other Requirements
* Source must be well-documented and clean

   ```addi  $t0, $t0, 1   # add 1 to $t0 - BAD COMMENT```

   ```addi  $t0, $t0, 1   # increment loop counter - GOOD COMMENT``` 

* Must write your own code
* Functionality for all preceeding stages must still work as you complete subsequent phases
* All phases must be written as a function
* Must demonstrate in class
