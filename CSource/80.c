/* 80.c

   $ gcc 80.c
   $ ./a.out abcdefg

   implementation of phase 80 in C 
   purpose: count even ASCII characters in the argument - do not count null byte */

#include <stdio.h>
#include <string.h>

char mystr[128] = "hello\0";
 
int main(int argc , char ** argv)
{
  if (argc == 2) 
     strcpy(mystr,argv[1]); 

  printf("%s\n",mystr);    
  
  int i = 0;        /* loop variable */ 
  int even_cnt = 0; /* holds count of even ascii values*/
  int mod2;         /* holds remainder of DIV operation */
  int ascii_value;  /* holds ascii decimal value of current character */ 

  while ( mystr[i] != 0 )  /* the null byte is ascii value 0 */ 
  {
   
    ascii_value = mystr[i];  /* grab the current ascii value */

    printf("%c ",ascii_value);  /* display ascii value as a character */
    printf("%d ",ascii_value);  /* for debugging display ascii value as int */

    mod2 =  ascii_value % 2;  /* in MIPS do DIV/2 and MFHI to grab remainder */

    if (mod2 == 0)   /* in MIPS do a BEQZ */
       even_cnt++;   
 
    i++;

  }

  printf("%c",10); /* display a linefeed at the end (ascii value 10)*/

  /* display the count of even ascii characters */
  printf("%d\n",even_cnt); /* display a linefeed at the end (ascii value 10)*/

  return 0;
}
