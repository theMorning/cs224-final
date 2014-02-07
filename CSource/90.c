/* 90.c
 *
 *  $ gcc 90.c
 *  $ ./a.out abcdefg
 *  gfedcba
 *
 *  implementation of phase 90 in C 
 *  write and call function to return lowest ascii char in arg
 *  display that character
 */

#include <stdio.h>
#include <string.h>

void rev(char *  );

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


  rev(mystr);
  printf("%s\n",mystr); 
  rev(mystr);
  printf("%s\n",mystr); 


  return 0;
}

/* function the reverse the characters in a string in-place */
void rev(char * mystr  )
{
  char ch;
  int head, tail;

  head = 0;
  tail = 0;

  /* find the tail of the string */
  while ( (ch = mystr[tail]) != 0 )   
      tail++;
  tail--;  /* backup past null char */

  char tmp;
  while ( head < tail ) {
     tmp = mystr[head];
     mystr[head] = mystr[tail];
     mystr[tail] = tmp;
     head++;
     tail--;
  }

}
