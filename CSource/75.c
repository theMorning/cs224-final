/* implementation of phase 75 in C */
#include <stdio.h>
#include <string.h>

/* hard-code a default string - if arg is passed you overwrite the hard-coded
   one; fyi: the passed argument is terminated with a null byte for you */

char mystr[128] = "hello\0";
 
int main(int argc , char ** argv)
{
  /* if arg count==2 you know an arg was passed so use it */
  if (argc == 2) 
     strcpy(mystr,argv[1]); /* in MIPS just grab the address to the arg */

  printf("%s\n",mystr);    /* this is from phase 70 - keep it */
  
  /* phase 75 - print each character in mystr separated by a space */

  int i = 0;  /* i is the offset into the string - i points to current byte */ 
  while ( mystr[i] != 0 )  /* stop when you hit the null byte */ 
  {
    printf("%c ",mystr[i]);
    i++;
  }
  /* display a linefeed at the end (ascii value 10)*/
  printf("%c",10);

  return 0;
}
